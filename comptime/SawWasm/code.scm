(module saw_wasm_code
  (include "Tools/trace.sch"
      "Tools/location.sch")
  (import type_type		; type
    ast_var		; local/global
    ast_node		; atom
    ast_env
    module_module	; *module*
    engine_param		; *stdc* ...

    type_tools		; for emit-atom-value/make-typed-declaration
    type_cache		; for emit-atom-value
    type_typeof
    object_class
    cnst_alloc
    tools_shape
    backend_backend
    backend_cvm
    backend_wasm
    backend_c_emit
    saw_defs
    saw_woodcutter
    saw_node2rtl
    saw_expr
    saw_regset
    saw_register-allocation
    saw_bbv)
  (export
    (saw-wasm-gen b::wasm v::global)
    (wasm-type t::type #!optional (may-null #t))
    (wasm-sym t::bstring))
  (cond-expand ((not bigloo-class-generate) (include "SawWasm/code.sch")))
  (static (wide-class SawCIreg::rtl_reg index)))

(define (saw-wasm-gen b::wasm v::global)
  (let ((l (global->blocks b v)))
    (gen-fun b v l)))

(define (needs-dispatcher? l)
   ; if there is a single basic block or none, then we don't have any control flow
   ; and therefore we are sure that we don't need a dispatcher block.
   (not (or
      (null? l) 
      (null? (cdr l)))
   ))

(define (gen-fun b::wasm v::global l)
   (with-access::global v (name import value type)
      (with-access::sfun value (args)
         (let ((params (map local->reg args)))
            (build-tree b params l)
            (set! l (register-allocation b v params l))
            (set! l (bbv b v params l))

            `(func ,(wasm-sym name)

              ,@(if (eq? import 'export)
                  `((export ,name))
                  '())

              ,@(let ((locals (get-locals params l)))
                `(,@(gen-params params)
                ,@(gen-result type)
                ,@(gen-locals locals)))

              ,@(if (needs-dispatcher? l)
                    `((local $__label i32)
                      (local.set $__label (i32.const ,(block-label (car l))))
                      ,@(gen-body l))
                    (gen-basic-block (car l))))))))

(define (get-locals params l) ;()
   ;; update all reg to ireg and  return all regs not in params.
   (let ( (n 0) (regs '()) )
      (define (expr->ireg e)
   (cond
      ((isa? e SawCIreg))
      ((rtl_reg? e) (widen!::SawCIreg e (index n))
        (set! n (+fx n 1))
        (set! regs (cons e regs)) )
      (else
      (map expr->ireg (rtl_ins-args e)) )))
      (define (visit b::block)
   (for-each
    (lambda (ins)
      (with-access::rtl_ins ins (dest fun args)
    (if dest (expr->ireg dest))
    (for-each expr->ireg args) ))
    (block-first b) ))
      (for-each expr->ireg params)
      (set! regs '())
      (for-each visit l)
      regs ))

(define (wasm-type t::type #!optional (may-null #t))
  (let ((id (type-id t))
        (name (type-name t)))
    (case id
      ('obj 'eqref)
      ('nil 'eqref)
      ('unspecified 'eqref)
      ('class-field 'eqref)
      ('pair-nil 'eqref)
      ('cobj 'eqref)
      ('void* 'i32) ;; A raw pointer into the linear memory
      ('tvector 'arrayref)
      ;; TODO: handle procedure-el and procedure-l
      ('procedure-el (if may-null '(ref null $procedure) '(ref $procedure)))
      ('bool 'i32)
      ('byte 'i32)
      ('ubyte 'i32)
      ('char 'i32)
      ('uchar 'i32)
      ('ucs2 'i32)
      ('int8 'i32)
      ('uint8 'i32)
      ('int16 'i32)
      ('uint16 'i32)
      ('int32 'i32)
      ('uint32 'i32)
      ('int64 'i64)
      ('uint64 'i64)
      ('int 'i32)
      ('uint 'i32)
      ('long 'i64)
      ('ulong 'i64)
      ('elong 'i64)
      ('uelong 'i64)
      ('llong 'i64)
      ('ullong 'i64)
      ('float 'f32)
      ('double 'f64)
      ;; FIXME: remove the null qualifier
      ('vector (if may-null '(ref null $vector) '(ref $vector)))
      ('string (if may-null '(ref null $bstring) '(ref $bstring))) ; string and bstring are the same
      (else 
        (cond 
          ((foreign-type? t) `(todo ,(type-id t)))
          ((string-suffix? "_bglt" name) (if may-null `(ref null ,(wasm-sym name)) `(ref ,(wasm-sym name))))
          ;; FIXME: remove the null qualifier
          (else (if may-null 
            `(ref null ,(wasm-sym (symbol->string (type-id t))))
            `(ref ,(wasm-sym (symbol->string (type-id t)))) )))))))

(define (gen-params l) ;()
  (map (lambda (arg) `(param ,(wasm-sym (reg_name arg)) ,(wasm-type (rtl_reg-type arg)))) l))

(define (gen-result t)
  (if (eq? (type-id t) 'void)
    '()
    `((result ,(wasm-type t)))))

(define (gen-locals l)
  (map (lambda (local) `(local ,(wasm-sym (reg_name local)) ,(wasm-type (rtl_reg-type local)))) l))

(define (reg_name reg) ;()
  (or (rtl_reg-debugname reg)
      (string-append (if (SawCIreg-var reg) "V" "R")
      (integer->string (SawCIreg-index reg)) )))

(define (gen-body blocks)
  `((loop $__dispatcher
    ,@(letrec ((iter-block (lambda (l label)
        (if (null? l)
          `((block ,(wasm-block-sym label) ,(gen-dispatcher blocks)))
          (let ((bb (car l)))
            (if label
              `((block ,(wasm-block-sym label) ,@(iter-block (cdr l) (block-label bb)) ,@(gen-basic-block bb)))
              `(,@(iter-block (cdr l) (block-label bb)) ,@(gen-basic-block bb))))))))
      (iter-block (reverse blocks) #f)))))

(define (wasm-block-sym label)
  (string->symbol (string-append "$bb_" (integer->string label))))

(define (wasm-block-label b)
  (wasm-block-sym (block-label b)))

(define (gen-dispatcher blocks)
  `(br_table ,@(map wasm-block-label blocks) (local.get $__label)))

(define (gen-basic-block b)
  (filter-map gen-ins (block-first b)))

(define-generic (do-push? fun::rtl_fun) #f)

; TODO: add remaining instructions
(define-method (do-push? fun::rtl_loadi) #t)
(define-method (do-push? fun::rtl_loadg) #t)
(define-method (do-push? fun::rtl_nop) #t)
(define-method (do-push? fun::rtl_funcall) #t)
(define-method (do-push? fun::rtl_valloc) #t)
(define-method (do-push? fun::rtl_vref) #t)
(define-method (do-push? fun::rtl_vlength) #t)
(define-method (do-push? fun::rtl_boxref) #t)
(define-method (do-push? fun::rtl_cast) #t)
(define-method (do-push? fun::rtl_new) #t)
(define-method (do-push? fun::rtl_getfield) #t)
(define-method (do-push? fun::rtl_makebox) #t)
(define-method (do-push? fun::rtl_mov) #t) ;; FIXME: not correct depends on arguments
(define-method (do-push? fun::rtl_call)
  (let ((retty (variable-type (rtl_call-var fun))))
    (not (eq? (type-id retty) 'void))))

; TODO: implement do-push? for other types

(define (gen-ins ins::rtl_ins)
  (with-access::rtl_ins ins (dest fun args)
    (if dest
      `(local.set ,(gen-reg/dest dest) ,(gen-expr fun args))
      ; We need to add an explicit drop if the instruction push
      ; some data to the stack. Indeed, at the end of each block
      ; the stack must be empty (all pushed values must have been
      ; popped).
      (if (do-push? fun) `(drop ,(gen-expr fun args)) (gen-expr fun args)))))

(define-generic (gen-expr fun::rtl_fun args) #unspecified)

(define (gen-args args)
  (map (lambda (arg) (gen-reg arg)) args))

(define (gen-reg reg)
  (if (isa? reg SawCIreg)
    `(local.get ,(gen-reg/dest reg))
    (gen-expr (rtl_ins-fun reg) (rtl_ins-args reg))))

(define (gen-reg/dest reg)
  (if (rtl_reg-debugname reg)
    (wasm-sym (rtl_reg-debugname reg))
    (wasm-sym
      (string-append
        (if (SawCIreg-var reg) "V" "R")
        (fixnum->string (SawCIreg-index reg))))))

(define-method (gen-expr fun::rtl_nop args)
  ;; Strangely, NOP is defined as returning the constant BUNSPEC...
  '(global.get $BUNSPEC))

(define-method (gen-expr fun::rtl_globalref args)
  ; NOT IMPLEMENTED
  '(GLOBALREF ,@(gen-args args)))

(define-method (gen-expr fun::rtl_getfield args)
  (with-access::rtl_getfield fun (name objtype)
    `(struct.get ,(wasm-sym (type-class-name objtype)) ,(wasm-sym name) ,@(gen-args args))))

(define-method (gen-expr fun::rtl_setfield args)
  (with-access::rtl_setfield fun (name objtype)
    `(struct.set ,(wasm-sym (type-class-name objtype)) ,(wasm-sym name) ,@(gen-args args))))

(define-method (gen-expr fun::rtl_instanceof args)
  ; NOT IMPLEMENTED
  `(INSTANCEOF ,@(gen-args args)))

(define-method (gen-expr fun::rtl_makebox args)
  `(struct.new $cell ,@(gen-args args)))

(define-method (gen-expr fun::rtl_boxref args)
  ;; FIXME: remove the cast to cell
  `(struct.get $cell $car (ref.cast (ref $cell) ,(gen-reg (car args)))))

(define-method (gen-expr fun::rtl_boxset args)
  ;; FIXME: remove the cast to cell
  `(struct.set $cell $car (ref.cast (ref $cell) ,(gen-reg (car args))) ,@(gen-args (cdr args))))

(define-method (gen-expr fun::rtl_fail args)
  ;; TODO
  '(throw $fail))

(define-method (gen-expr fun::rtl_return args)
  `(return ,@(gen-args args)))

(define-method (gen-expr fun::rtl_go args)
  ; We can not return a list of WASM instruction there (as it is not the 
  ; expected interface by the callers of this function). Therefore, we
  ; need to encapsulate the two instructions inside a WASM block.
  `(block ,@(gen-go (rtl_go-to fun))))

(define-method (gen-expr fun::rtl_ifne args)
  `(if ,@(gen-args args) (then ,@(gen-go (rtl_ifne-then fun)))))

(define-method (gen-expr fun::rtl_ifeq args)
  `(if (i32.eqz ,@(gen-args args)) (then ,@(gen-go (rtl_ifeq-then fun)))))

;*---------------------------------------------------------------------*/
;*    intify ...                                                       */
;*---------------------------------------------------------------------*/
(define (intify x)
   (cond
    ((fixnum? x) x)
    ((uint32? x) (uint32->fixnum x))
    ((int32? x) (int32->fixnum x))
    (else x)))

(define-method (gen-expr fun::rtl_switch args)
  (with-access::rtl_switch fun (type patterns labels)
    (let ((else-bb #unspecified) (num2bb '()))
      (define (add n bb)
        (set! num2bb (cons (cons (intify n) bb) num2bb)))

      (for-each (lambda (pat bb)
        (if (eq? pat 'else)
          (set! else-bb bb)
          (for-each (lambda (n) (add n bb)) pat)))
        patterns labels)
        
      (set! num2bb (sort num2bb (lambda (x y) (<fx (car x) (car y)))))
      (let* ((nums (map car num2bb))
        (min (car nums))
        (max (car (last-pair nums)))
        (n (length nums)))
        
        ;; TODO: generate a binary search if the density is too low.
        ;;       see SawJvm/code.scm: rtl_switch gen-fun
        
        (emit-binary-search type (gen-args args) else-bb (list->vector (map car num2bb)) (list->vector (map cdr num2bb)))
        ; Code to generate br_table (to be used once Relooper is implemented).
        ; `(br_table ,@(map wasm-block-label (flat num2bb else-bb)) ,(wasm-block-label else-bb) (i64.sub ,@(gen-args args) (i64.const ,min)))
      ))))

(define (cmp-ops-for-type type)
  (case (type-id type)
    ('char (values 'i32.lt_s 'i32.gt_s 'i32.const))
    ('uchar (values 'i32.lt_u 'i32.gt_u 'i32.const))
    ('byte (values 'i32.lt_s 'i32.gt_s 'i32.const))
    ('ubyte (values 'i32.lt_u 'i32.gt_u 'i32.const))
    ('int8 (values 'i32.lt_s 'i32.gt_s 'i32.const))
    ('uint8 (values 'i32.lt_u 'i32.gt_u 'i32.const))
    ('int16 (values 'i32.lt_s 'i32.gt_s 'i32.const))
    ('uint16 (values 'i32.lt_u 'i32.gt_u 'i32.const))
    ('int32 (values 'i32.lt_s 'i32.gt_s 'i32.const))
    ('uint32 (values 'i32.lt_u 'i32.gt_u 'i32.const))
    ('int (values 'i32.lt_s 'i32.gt_s 'i32.const))
    ('int64 (values 'i64.lt_s 'i64.gt_s 'i64.const))
    ('uint64 (values 'i64.lt_u 'i64.gt_u 'i64.const))
    (else (values 'i64.lt_s 'i64.gt_s 'i64.const))))

;*---------------------------------------------------------------------*/
;*    emit-binary-search ...                                           */
;*---------------------------------------------------------------------*/
(define (emit-binary-search type args else-bb patterns blocks)
  (multiple-value-bind (lt gt const) (cmp-ops-for-type type)
    (let helper ((low 0)
                (high (-fx (vector-length patterns) 1)))
      (if (<fx high low)
        `(block ,@(gen-go else-bb))
        (let ((middle (quotient (+fx low high) 2)))
          `(if (,gt (,const ,(vector-ref patterns middle)) ,@args)
            (then ,(helper low (-fx middle 1)))
            (else
              (if (,lt (,const ,(vector-ref patterns middle)) ,@args)
                (then ,(helper (+fx middle 1) high))
                (else ,@(gen-go (vector-ref blocks middle)))))))))))

;*---------------------------------------------------------------------*/
;*    flat ...                                                         */
;*---------------------------------------------------------------------*/
(define (flat al ldef)
  (define (walk al i r)
    (cond
      ((null? al) (reverse! r))
      ((=fx i (caar al)) (walk (cdr al) (+fx i 1) (cons (cdar al) r)))
      ((>fx i (caar al)) (walk (cdr al) i r))
      (else (walk al (+fx i 1) (cons ldef r)))))
  (walk al (caar al) '()))

(define-method (gen-expr fun::rtl_loadfun args)
  ; We need to encapsulate the funcref into a struct so it can be passed
  ; to functions taking eqref (like make-fx-procedure).
  `(struct.new $tmpfun (ref.func ,(wasm-sym (global-name (rtl_loadfun-var fun))))))

(define-method (gen-expr fun::rtl_valloc args)
  `(array.new_default $vector (i32.wrap_i64 ,@(gen-args args))))

(define-method (gen-expr fun::rtl_vref args)
  ; Bigloo generate 64-bit indices, but Wasm expect 32-bit indices, thus the i32.wrap_i64.
  ;; FIXME: is the cast to ref vector really required?
  `(array.get $vector (ref.cast (ref $vector) ,(gen-reg (car args))) (i32.wrap_i64 ,(gen-reg (cadr args)))))

(define-method (gen-expr fun::rtl_vset args)
  ; Bigloo generate 64-bit indices, but Wasm expect 32-bit indices, thus the i32.wrap_i64.
  ;; FIXME: is the cast to ref vector really required?
  `(array.set $vector (ref.cast (ref $vector) ,(gen-reg (car args))) (i32.wrap_i64 ,(gen-reg (cadr args))) ,@(gen-args (cddr args))))

(define-method (gen-expr fun::rtl_vlength args)
  `(i64.extend_i32_u (array.len ,@(gen-args args))))

(define (emit-wasm-atom-value type value)
   (cond
      ; TODO: better reusable code? maybe use a macro, too many repetitions
      ((boolean? value) `(i32.const ,(if value 1 0)))
      ((null? value) '(ref.null none))
      ((char? value) `(i32.const ,(char->integer value)))
      ((int8? value) `(i32.const ,(int8->fixnum value)))
      ((uint8? value) `(i32.const ,(uint8->fixnum value)))
      ((int16? value) `(i32.const ,(int16->fixnum value)))
      ((uint16? value) `(i32.const ,(uint16->fixnum value)))
      ((int32? value) `(i32.const ,(int32->llong value)))
      ((uint32? value) `(i32.const ,(uint32->llong value)))
      ((int64? value) `(i64.const ,(int64->llong value)))
      ((uint64? value) `(i64.const ,(uint64->llong value)))
      ((elong? value) `(i64.const ,value))
      ((llong? value) `(i64.const ,value))
      ((ucs2? value) `(i32.const ,(ucs2->integer value)))
      ((fixnum? value)
        ;; TODO: support other types
        (if (eq? (type-id type) 'int)
        `(i32.const ,value)
        `(i64.const ,value)))
      ((flonum? value) 
        (cond
          ((nanfl? value) `(f64.const nan))
          ((and (infinitefl? value) (>fl value 0.0)) `(f64.const inf))
          ((infinitefl? value) `(f64.const -inf))
          (else `(f64.const ,value))))
      ((eq? value #unspecified) '(global.get $BUNSPEC))
      ((eq? value __eoa__) '(global.get $BEOA))
      ((bignum? value) '(ref.null none)) ; TODO: implement bignum
      ((string? value) `(array.new_default $bstring (i32.const ,(string-length value)))) ; FIXME: implement C string constants
      ((cnst? value)
        (cond
          ((eof-object? value) '(global.get $BEOF))
          ((eq? value boptional) '(global.get $BOPTIONAL))
          ((eq? value bkey) '(global.get $BKEY))
          ((eq? value brest) '(global.get $BREST))
          ((eq? value __eoa__) '(global.get $BEOA))
          (else `(BCNST ,(cnst->integer value)))))
      (else `(TYPE ,(typeof value))) ; TODO: support other types, see emit-atom-value in c_emit.scm
   ))

(define-method (gen-expr fun::rtl_loadi args)
  (let ((atom (rtl_loadi-constant fun)))
    (emit-wasm-atom-value (atom-type atom) (atom-value atom))))

(define-method (gen-expr fun::rtl_loadg args)
  (let* ((var (rtl_loadg-var fun))
          (name (global-name var))
          (macro-code (global-jvm-type-name var)))
    (if (and (isa? (global-value var) cvar)
            (not (string-null? macro-code)))
      (expand-wasm-macro (call-with-input-string macro-code read) (gen-args args))
      `(global.get ,(wasm-sym (global-name (rtl_loadg-var fun)))))))

(define-method (gen-expr fun::rtl_storeg args)
  `(global.set ,(wasm-sym (global-name (rtl_storeg-var fun))) ,@(gen-args args)))

;*---------------------------------------------------------------------*/
;*    wasm-sym ...                                                     */
;*---------------------------------------------------------------------*/
(define (wasm-sym ident)
  ; All symbolic references are prefixed by $ in Wasm textual format.
  (string->symbol (string-append "$" ident)))

;*---------------------------------------------------------------------*/
;*    gen-go ...                                                       */
;*---------------------------------------------------------------------*/
(define (gen-go to::block)
  ; Generate something like:
  ;   (local.set $label (i32.const BLOCK_LABEL))
  ;   (br $dispatcher)
  ; This is used to simulate gotos (because they don't exist as is in Wasm).
  ; See (gen-body) to understand what $dispatcher is.

  `((local.set $__label (i32.const ,(block-label to)))
    (br $__dispatcher)))

;*---------------------------------------------------------------------*/
;*    expand-wasm-macro ...                                            */
;*    -------------------------------------------------------------    */
;*    Takes a Scheme list, symbol or atom value and replaces all       */
;*    occurrences of symbols ~k (with k an integer) to the k-th        */
;*    argument of this function.                                       */
;*    Example:                                                         */
;*      (expand-wasm-macro `(local.get ~0) `(1 2 3) #t "hello")        */
;*    gives                                                            */
;*      (local.get (1 2 3))                                            */
;*---------------------------------------------------------------------*/
(define (expand-wasm-macro macro args)
  (cond 
    ((symbol? macro)
      (let ((name (symbol->string macro)))
        (if (string-prefix? "~" name)
          (let ((index (string->integer (substring name 1))))
            (list-ref args index))
          macro)))
    ((pair? macro) (map (lambda (n) (expand-wasm-macro n args)) macro))
    (else macro)))

(define-method (gen-expr fun::rtl_call args)  
  (let* ((var (rtl_call-var fun))
          (name (global-name var))
          (macro-code (global-jvm-type-name var)))
    (if (and (isa? (global-value var) cfun)
            (not (string-null? macro-code)))
      (expand-wasm-macro (call-with-input-string macro-code read) (gen-args args))
      `(call ,(wasm-sym name) ,@(gen-args args)))))

(define-method (gen-expr fun::rtl_funcall args)
  (gen-expr-funcall/lightfuncall args))

(define-method (gen-expr fun::rtl_lightfuncall args)
  ; TODO: implement lightfuncall
  `(ref.cast ,(wasm-type (rtl_lightfuncall-rettype fun) #f) ,(gen-expr-funcall/lightfuncall args)))

(define (gen-expr-funcall/lightfuncall args)
  (let* ((arg_count (length args))
         (func_type (wasm-sym (string-append "func" (fixnum->string arg_count))))
         (proc `(ref.cast (ref $procedure) ,(gen-reg (car args)))))
    `(if (result eqref) (i32.lt_s (struct.get $procedure $arity ,proc) (i32.const 0)) 
      (then ; Is a variadic function!
        (call 
          $generic_va_call 
          ,proc 
          (array.new_fixed $vector ,(-fx arg_count 1) ,@(gen-args (cdr args))))
      )
      (else
        (call_ref 
          ,func_type 
          ,@(gen-args args) 
          (ref.cast 
            (ref ,func_type) 
            (struct.get $procedure $entry ,proc)))))))

(define-method (gen-expr fun::rtl_apply args)
  ; TODO
  `(throw $fail))

(define-method (gen-expr fun::rtl_mov args)
  (gen-reg (car args)))

(define-method (gen-expr fun::rtl_new args)
  ; NOT IMPLEMENTED
  (with-access::rtl_new fun (type constr)
    (let ((alloc `(struct.new_default ,(wasm-sym (type-class-name type)))))
    (if constr
      alloc
      ; TODO: call constructor
      `(block ,alloc)))))

(define-method (gen-expr fun::rtl_cast args)
  ;; (tprint (typeof (rtl_ins-fun (car args))))
  (let ((type (rtl_cast-totype fun)))
    (case (type-id type)
      ('obj (gen-reg (car args)))
      (else `(ref.cast ,(wasm-type type) ,(gen-reg (car args)))))))

(define-method (gen-expr fun::rtl_cast_null args)
  ; NOT IMPLEMENTED
  `(CASTNULL ,@(gen-args args)))

(define-method (gen-expr fun::rtl_pragma args)
  (if (eq? (rtl_pragma-srfi0 fun) 'bigloo-wasm)
    (let ((format (rtl_pragma-format fun)))
      (call-with-input-string format read))
    ;; TODO: implement pragma default value depending on type
    '(global.get $BUNSPEC)))

(define-method (gen-expr fun::rtl_jumpexit args)
  `(throw $bexception ,@(gen-args args)))

(define-method (gen-expr fun::rtl_protect args)
  ;; TODO: correctly initialize exit object
  '(struct.new_default $exit))

(define-method (gen-expr fun::rtl_protected args)
  ;; Strange, nothing to do...
  (gen-reg (car args)))
