;*=====================================================================*/
;*    .../prgm/project/bigloo/bigloo/comptime/liveness/liveness.scm        */
;*    -------------------------------------------------------------    */
;*    Author      :  Manuel Serrano                                    */
;*    Creation    :  Sun Nov 10 07:53:36 2013                          */
;*    Last change :  Thu Jul  8 12:59:34 2021 (serrano)                */
;*    Copyright   :  2013-21 Manuel Serrano                            */
;*    -------------------------------------------------------------    */
;*    Def/Use node property with fix point iteration.                  */
;*=====================================================================*/

;*---------------------------------------------------------------------*/
;*    The module                                                       */
;*---------------------------------------------------------------------*/
(module defuse_defuse
   (include "Tools/trace.sch")
   (import  tools_error
	    tools_shape
	    type_type
	    type_typeof
	    type_cache
	    type_env
	    ast_var
	    ast_node
	    ast_env
	    module_module
	    engine_param
	    defuse_types
	    defuse_set)
   (export (liveness-sfun! ::sfun)
	   (liveness-live ::node)))

;*---------------------------------------------------------------------*/
;*    liveness-sfun! ...                                               */
;*    -------------------------------------------------------------    */
;*    Compute the liveness property of function AST.                   */
;*    -------------------------------------------------------------    */
;*    This function implements a fix point interation to find the      */
;*    maximal solution of the equations:                               */
;*       in[ n ] = use[ n ] U (out[ n ] - def[ n ])                    */
;*      out[ n ] = Union(succ[ n ]) in[ s ]                            */
;*---------------------------------------------------------------------*/
(define (liveness-sfun! value::sfun)
   (with-access::sfun value (args body)
      (for-each (lambda (l) (widen!::local/liveness l)) args)
      (defuse body)
      (inout! body '())))

;*---------------------------------------------------------------------*/
;*    liveness-live ...                                                */
;*---------------------------------------------------------------------*/
(define (liveness-live node)
   (multiple-value-bind (in out)
      (inout node)
      (intersection in out)))

;*---------------------------------------------------------------------*/
;*    defuse* ...                                                      */
;*---------------------------------------------------------------------*/
(define (defuse* nodes::pair-nil def::pair-nil use::pair-nil)
   (let loop ((nodes nodes)
	      (def def)
	      (use use))
      (if (null? nodes)
	  (values def use)
	  (multiple-value-bind (d u)
	     (defuse (car nodes))
	     (loop (cdr nodes) (union d def) (union u use))))))

;*---------------------------------------------------------------------*/
;*    defuse-seq ...                                                   */
;*---------------------------------------------------------------------*/
(define (defuse-seq nodes::pair-nil)
   (let loop ((nodes nodes)
	      (def '())
	      (use '()))
      (if (null? nodes)
	  (values def use)
	  (multiple-value-bind (d u)
	     (defuse (car nodes))
	     (loop (cdr nodes)
		(union def d)
		(union use (disjonction u def)))))))

;*---------------------------------------------------------------------*/
;*    inout*! ...                                                      */
;*---------------------------------------------------------------------*/
(define (inout*! nodes::pair-nil out)
   (let loop ((sedon (reverse nodes))
	      (out out))
      (when (pair? sedon)
	 (multiple-value-bind (nin nout)
	    (inout*! (car sedon) out)
	    (loop (cdr sedon) nout)))))

;*---------------------------------------------------------------------*/
;*    defuse ::node ...                                                */
;*    -------------------------------------------------------------    */
;*    Returns two values: def x use                                    */
;*    Does not store anything in the node                              */
;*---------------------------------------------------------------------*/
(define-generic (defuse n::node)
   (values '() '()))

(define-generic (inout! n::node out)
   (values '() out))

(define-generic (inout n::node)
   (values '() '()))

;*---------------------------------------------------------------------*/
;*    defuse ::literal ...                                             */
;*---------------------------------------------------------------------*/
(define-method (defuse n::literal)
   (widen!::literal/liveness n)
   (values '() '()))

(define-method (defuse n::literal/liveness)
   (values '() '()))

(define-method (inout! n::literal/liveness o)
   (with-access::literal/liveness n (def use in out)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (values in out)))

(define-method (inout n::literal/liveness)
   (with-access::literal/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::ref ...                                                 */
;*---------------------------------------------------------------------*/
(define-method (defuse n::ref)
   (with-access::ref n (variable)
      (let ((use (if (isa? variable local) (list variable) '())))
	 (defuse
	    (widen!::ref/liveness n
	       (def '())
	       (use use))))))

(define-method (defuse n::ref/liveness)
   (with-access::ref/liveness n (def use)
      (values def use)))

(define-method (inout! n::literal/liveness o)
   (with-access::literal/liveness n (def use in out)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (values in out)))

(define-method (inout n::literal/liveness)
   (with-access::literal/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::sequence ...                                            */
;*---------------------------------------------------------------------*/
(define-method (defuse n::sequence)
   (with-access::sequence n (nodes)
      (multiple-value-bind (def use)
	 (defuse-seq nodes)
	 (defuse 
	    (widen!::sequence/liveness n
	       (def def)
	       (use use))))))

(define-method (defuse n::sequence/liveness)
   (with-access::sequence/liveness n (nodes def use in out)
      (values def use)))

(define-method (inout! n::sequence/liveness o)
   (with-access::sequence/liveness n (nodes def use in out)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (inout*! nodes o)
      (values in out)))

(define-method (inout n::sequence/liveness)
   (with-access::sequence/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::app ...                                                 */
;*---------------------------------------------------------------------*/
(define-method (defuse n::app)
   (with-access::app n (fun args)
      (multiple-value-bind (d u)
	 (defuse fun)
	 (multiple-value-bind (def use)
	    (defuse* args d u)
	    (defuse
	       (widen!::app/liveness n
		  (def def)
		  (use use)))))))

(define-method (defuse n::app/liveness)
   (with-access::app/liveness n (def use)
      (values def use)))

(define-method (inout! n::app/liveness o)
   (with-access::app/liveness n (in out use def args)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (for-each (lambda (a) (inout! args o)) args)
      (values in out)))

(define-method (inout n::app/liveness)
   (with-access::app/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::app-ly ...                                              */
;*---------------------------------------------------------------------*/
(define-method (defuse n::app-ly)
   (with-access::app-ly n (fun arg)
      (multiple-value-bind (deffun usefun)
	 (defuse fun)
	 (multiple-value-bind (defarg usearg)
	    (defuse arg)
	    (defuse
	       (widen!::app-ly/liveness n
		  (def (union deffun defarg))
		  (use (union usefun usearg))))))))

(define-method (defuse n::app-ly/liveness)
   (with-access::app-ly/liveness n (use def)
      (values def use)))

(define-method (inout! n::app-ly/liveness o)
   (with-access::app-ly/liveness n (in out use def arg)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (inout! arg o)
      (values in out)))

(define-method (inout n::app-ly/liveness)
   (with-access::app-ly/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::funcall ...                                             */
;*---------------------------------------------------------------------*/
(define-method (defuse n::funcall)
   (with-access::funcall n (fun args)
      (multiple-value-bind (d u)
	 (defuse fun)
	 (multiple-value-bind (def use)
	    (defuse* args d u)
	    (defuse
	       (widen!::funcall/liveness n
		  (def def)
		  (use use)))))))

(define-method (defuse n::funcall/liveness)
   (with-access::funcall/liveness n (def use)
      (values def use)))

(define-method (inout! n::funcall/liveness o)
   (with-access::funcall/liveness n (in out use def args)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (for-each (lambda (a) (inout! args o)) args)
      (values in out)))

(define-method (inout n::funcall/liveness)
   (with-access::funcall/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::extern ...                                              */
;*---------------------------------------------------------------------*/
(define-method (defuse n::extern)
   (with-access::extern n (expr*)
      (defuse* expr* '() '())))

;*---------------------------------------------------------------------*/
;*    defuse ::pragma ...                                              */
;*---------------------------------------------------------------------*/
(define-method (defuse n::pragma)
   (with-access::pragma n (expr*)
      (multiple-value-bind (def use)
	 (defuse* expr* '() '())
	 (defuse
	    (widen!::pragma/liveness n
	       (def def)
	       (use use))))))

(define-method (defuse n::pragma/liveness)
   (with-access::pragma/liveness n (def use)
      (values def use)))

(define-method (inout! n::pragma/liveness o)
   (with-access::pragma/liveness n (in out def use expr*)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (for-each (lambda (e) (inout! e o)) expr*)
      (values in out)))

(define-method (inout n::pragma/liveness)
   (with-access::pragma/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::cast ...                                                */
;*---------------------------------------------------------------------*/
(define-method (defuse n::cast)
   (with-access::cast n (arg)
      (multiple-value-bind (def use)
	 (defuse arg)
	 (defuse
	    (widen!::cast/liveness n
	       (def def)
	       (use use))))))

(define-method (defuse n::cast/liveness)
   (with-access::cast/liveness n (def use)
      (values def use)))

(define-method (inout! n::cast/liveness o)
   (with-access::cast/liveness n (in out def use arg)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (inout! arg o)
      (values in out)))

(define-method (inout n::cast/liveness)
   (with-access::cast/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::setq ...                                                */
;*---------------------------------------------------------------------*/
(define-method (defuse n::setq)
   (with-access::setq n (var value)
      (multiple-value-bind (defvalue usevalue)
	 (defuse value)
	 (with-access::var var ((v variable))
	    (when (isa? v local/liveness)
	       (set! defvalue (add v defvalue)))
	    (defuse
	       (widen!::setq/liveness n
		  (def defvalue)
		  (use usevalue)))))))

(define-method (defuse n::setq/liveness)
   (with-access::setq/liveness n (def use)
      (values def use)))
   
(define-method (inout! n::setq/liveness o)
   (with-access::setq/liveness n (def use in out)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (values in out)))

(define-method (inout n::setq/liveness)
   (with-access::setq/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::conditional ...                                         */
;*---------------------------------------------------------------------*/
(define-method (defuse n::conditional)
   (with-access::conditional n (test true false)
      (multiple-value-bind (deftest usetest)
	 (defuse test)
	 (multiple-value-bind (deftrue usetrue)
	    (defuse true)
	    (multiple-value-bind (deffalse usefalse)
	       (defuse false)
	       (defuse
		  (widen!::conditional/liveness n
		     (def (union deftest (intersection deftrue deffalse)))
		     (use (union usetest (disjonction (union usetrue usefalse) deftest))))))))))

(define-method (defuse n::conditional/liveness)
   (with-access::conditional/liveness n (def use)
      (values def use)))

(define-method (inout! n::conditional/liveness o)
   (with-access::conditional/liveness n (def use in out test true false)
      (set! out o)
      (inout! true o)
      (inout! false o)
      (multiple-value-bind (tdef tuse)
	 (defuse true)
	 (multiple-value-bind (fdef fuse)
	    (defuse false)
	    (inout! test (disjonction out (intersection tdef fdef)))))
      (set! in (union use (disjonction out def)))
      (values in out)))

(define-method (inout n::conditional/liveness)
   (with-access::conditional/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::fail ...                                                */
;*---------------------------------------------------------------------*/
(define-method (defuse n::fail)
   (with-access::fail n (proc msg obj)
      (multiple-value-bind (defproc useproc)
	 (defuse proc)
	 (multiple-value-bind (defmsg usemsg)
	    (defuse msg)
	    (multiple-value-bind (defobj useobj)
	       (defuse obj)
	       (defuse
		  (widen!::fail/liveness n
		     (def (union defproc defmsg defobj))
		     (use (union useproc usemsg useobj)))))))))

(define-method (defuse n::fail/liveness)
   (with-access::fail/liveness n (def use)
      (values def use)))
      
(define-method (inout! n::fail/liveness o)
   (with-access::fail/liveness n (in out use def proc msg obj)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (inout! proc o)
      (inout! msg o)
      (inout! obj o)
      (values in out)))

(define-method (inout n::fail/liveness)
   (with-access::fail/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::switch ...                                              */
;*---------------------------------------------------------------------*/
(define-method (defuse n::switch)
   (with-access::switch n (test clauses)
      (multiple-value-bind (deftest usetest)
	 (defuse test)
	 ;; compute separatly the def use props of all clauses
	 (let ((defs '())
	       (uses '()))
	    (for-each (lambda (clause)
			 (multiple-value-bind (def use)
			    (defuse (cdr clause))
			    (set! defs (cons def defs))
			    (set! uses (cons use uses))))
	       clauses)
	    (defuse
	       (widen!::switch/liveness n
		  (def (union deftest (apply intersection defs)))
		  (use (union usetest (disjonction (apply union uses) deftest)))))))))

(define-method (defuse n::switch/liveness)
   (with-access::switch/liveness n (def use)
      (values def use)))
      
(define-method (inout! n::switch/liveness o)
   (with-access::switch/liveness n (def use in out test clauses)
      (set! out o)
      (set! in (union use (disjonction out def)))
      ;; could be improved because we are not considering the intersection
      ;; of clauses def
      (inout! test o)
      (for-each (lambda (c) (inout! (cdr c) o)) clauses)
      (values in out)))

(define-method (inout n::switch/liveness)
   (with-access::switch/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::set-ex-it ...                                           */
;*---------------------------------------------------------------------*/
(define-method (defuse n::set-ex-it)
   (with-access::set-ex-it n (var body onexit)
      (with-access::var var (variable)
	 (widen!::local/liveness variable))
      (multiple-value-bind (defvar usevar)
	 (defuse var)
	 (multiple-value-bind (defbody usebody)
	    (defuse body)
	    (multiple-value-bind (defonx useonx)
	       (defuse onexit)
	       (defuse
		  (widen!::set-ex-it/liveness n
		     (def (union defvar (intersection defbody defonx)))
		     (use (union usevar (disjonction (union usebody useonx) defvar))))))))))

(define-method (defuse n::set-ex-it/liveness)
   (with-access::set-ex-it/liveness n (def use)
      (values def use)))
      
(define-method (inout! n::set-ex-it/liveness o)
   (with-access::set-ex-it/liveness n (def use in out body)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (inout! body o)
      (values in out)))

(define-method (inout n::set-ex-it/liveness)
   (with-access::set-ex-it/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::jump-ex-it ...                                          */
;*---------------------------------------------------------------------*/
(define-method (defuse n::jump-ex-it)
   (with-access::jump-ex-it n (exit value)
      (multiple-value-bind (defexit useexit)
	 (defuse exit)
	 (multiple-value-bind (defvalue usevalue)
	    (defuse value)
	    (defuse
	       (widen!::jump-ex-it/liveness n
		  (def (union defexit defvalue))
		  (use (union useexit usevalue))))))))

(define-method (defuse n::jump-ex-it/liveness)
   (with-access::jump-ex-it/liveness n (def use)
      (values def use)))
      
(define-method (inout! n::jump-ex-it/liveness o)
   (with-access::jump-ex-it/liveness n (def use in out value)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (inout! value o)
      (values in out)))

(define-method (inout n::jump-ex-it/liveness)
   (with-access::jump-ex-it/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::make-box ...                                            */
;*---------------------------------------------------------------------*/
(define-method (defuse n::make-box)
   (with-access::make-box n (value)
      (multiple-value-bind (def use)
	 (defuse value)
	 (defuse
	    (widen!::make-box/liveness n
	       (def def)
	       (use use))))))

(define-method (defuse n::make-box/liveness)
   (with-access::make-box/liveness n (def use)
      (values def use)))

(define-method (inout! n::make-box/liveness o)
   (with-access::make-box/liveness n (in out def use value)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (inout! value o)
      (values in out)))

(define-method (inout n::make-box/liveness)
   (with-access::make-box/liveness n (in out)
      (values in out)))
   
;*---------------------------------------------------------------------*/
;*    defuse ::box-ref ...                                             */
;*---------------------------------------------------------------------*/
(define-method (defuse n::box-ref)
   (with-access::box-ref n (var)
      (multiple-value-bind (def use)
	 (defuse var)
	 (defuse
	    (widen!::box-ref/liveness n
	       (use use)
	       (def def))))))

(define-method (inout! n::box-ref/liveness o)
   (with-access::box-ref/liveness n (var def use in out)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (inout! var o)
      (values in out)))

(define-method (inout n::box-ref/liveness)
   (with-access::box-ref/liveness n (in out)
      (values in out)))
   
;*---------------------------------------------------------------------*/
;*    defuse ::box-set! ...                                            */
;*---------------------------------------------------------------------*/
(define-method (defuse n::box-set!)
   (with-access::box-set! n (var value)
      (multiple-value-bind (defvalue usevalue)
	 (defuse value)
	 (multiple-value-bind (defvar usevar)
	    (defuse var)
	    (defuse
	       (widen!::box-set!/liveness n
		  (def (union defvalue defvar))
		  (use (union usevalue usevar))))))))

(define-method (defuse n::box-set!/liveness)
   (with-access::box-set!/liveness n (def use)
      (values def use)))

(define-method (inout! n::box-set!/liveness o)
   (with-access::box-set!/liveness n (value def use in out)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (inout! value o)
      (values in out)))

(define-method (inout n::box-set!/liveness)
   (with-access::box-set!/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::sync ...                                                */
;*---------------------------------------------------------------------*/
(define-method (defuse n::sync)
   (with-access::sync n (mutex prelock body)
      (multiple-value-bind (def use)
	 (defuse-seq (list prelock mutex body))
	 (defuse
	    (widen!::sync/liveness n
	       (def def)
	       (use use))))))

(define-method (defuse n::sync/liveness)
   (with-access::sync/liveness n (def use)
      (values def use)))

(define-method (inout! n::sync/liveness o)
   (with-access::sync/liveness n (def use in out body)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (inout! body o)
      (values in out)))

(define-method (inout n::sync/liveness)
   (with-access::sync/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::let-var ...                                             */
;*---------------------------------------------------------------------*/
(define-method (defuse n::let-var)
   (with-access::let-var n (bindings body)
      ;; bindings evaluation in unorder so cannot
      ;; be treated like a sequence
      (let ((defbindings '())
	    (usebindings '()))
	 (for-each (lambda (b)
		      (widen!::local/liveness (car b)))
	    bindings)
	 (for-each (lambda (b)
		      (multiple-value-bind (def use)
			 (defuse (cdr b))
			 (set! defbindings (union def defbindings))
			 (set! usebindings (union use usebindings))))
	    bindings)
	 (multiple-value-bind (defbody usebody)
	    (defuse body)
	    (defuse
	       (widen!::let-var/liveness n
		  (def (union defbindings defbody))
		  (use (union usebindings (disjonction usebody defbindings)))))))))

(define-method (defuse n::let-var/liveness)
   (with-access::let-var/liveness n (def use)
      (values def use)))

(define-method (inout! n::let-var/liveness o)
   (with-access::let-var/liveness n (def use body in out bindings)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (multiple-value-bind (def use)
	 (defuse body)
	 (multiple-value-bind (in out)
	    (inout! body out)
	    (for-each (lambda (b)
			 (inout! (cdr b) in))
	       bindings)))
      (values in out)))

(define-method (inout n::let-var/liveness)
   (with-access::let-var/liveness n (in out)
      (values in out)))

;*---------------------------------------------------------------------*/
;*    defuse ::let-fun ...                                             */
;*---------------------------------------------------------------------*/
(define-method (defuse n::let-fun)
   (with-access::let-fun n (locals body)
      ;; this is a conservative approach, we assume all functions called
      ;; for use but none called for def
      (let ((defbindings '())
	    (usebindings '()))
	 (for-each (lambda (fun)
		      (widen!::local/liveness fun)
		      (multiple-value-bind (def use)
			 (with-access::local fun (value)
			    (liveness-sfun! value))
			 (set! defbindings (union def defbindings))
			 (set! usebindings (union use usebindings))))
	    locals)
	 (multiple-value-bind (defbody usebody)
	    (defuse body)
	    (defuse
	       (widen!::let-fun/liveness n
		  (def (union defbody defbindings))
		  (use (union usebody usebindings))))))))

(define-method (defuse n::let-fun/liveness)
   (with-access::let-fun/liveness n (def use)
      (values def use)))

(define-method (inout! n::let-fun/liveness o)
   (with-access::let-fun/liveness n (def use locals body in out)
      (set! out o)
      (set! in (union use (disjonction out def)))
      (for-each (lambda (fun)
		   (with-access::local fun (value)
		      (with-access::sfun value (body)
			 (inout! body o))))
	 locals)
      (inout! body o)
      (values in out)))

(define-method (inout n::let-fun/liveness)
   (with-access::let-fun/liveness n (in out)
      (values in out)))
