;*=====================================================================*/
;*    serrano/prgm/project/bigloo/bigloo/tools/cfg.scm                 */
;*    -------------------------------------------------------------    */
;*    Author      :  Marc Feeley                                       */
;*    Creation    :  Mon Jul 17 08:14:47 2017                          */
;*    Last change :  Wed Dec 13 12:10:18 2023 (serrano)                */
;*    Copyright   :  2017-23 Manuel Serrano                            */
;*    -------------------------------------------------------------    */
;*    CFG (BB) dump for the dot program.                               */
;*    -------------------------------------------------------------    */
;*    The input file is generated by Bigloo with:                      */
;*                                                                     */
;*      bigloo file.scm -saw -fsaw-regalloc -fsaw-bbv -gself           */
;*                                                                     */
;*    The input basic-blocks dump is as follows:                       */
;*                                                                     */
;*    ;; -*- mode: bee -*-                                             */
;*    ;; *** sum:                                                      */
;*    ;; (!v)                                                          */
;*    (block 25                                                        */
;*     :preds ()                                                       */
;*     :succs (26)                                                     */
;*     [($g1130 <- (mov ($long->bint (loadi 0)))) (ctx ... ctx)]       */
;*     [(!s <- (mov ($long->bint (loadi 0)))) (ctx ... ctx)]           */
;*                                                                     */
;*    (block 26                                                        */
;*     ;; ictx=(#("$g1130" "bint") #("!s" "bint"))                     */
;*     :preds (25)                                                     */
;*     :succs (27 186)                                                 */
;*     [(ifeq ($vector? !v) 186) (ctx ... ctx)]                        */
;*                                                                     */
;*    ...                                                              */
;*=====================================================================*/

;*---------------------------------------------------------------------*/
;*    The module                                                       */
;*---------------------------------------------------------------------*/
(module cfg-dump
   (main main))

;*---------------------------------------------------------------------*/
;*    global parameters ...                                            */
;*---------------------------------------------------------------------*/
(define fontsize "")
(define compact #f)

;*---------------------------------------------------------------------*/
;*    bb ...                                                           */
;*---------------------------------------------------------------------*/
(define-struct bb lbl-num preds succs instrs parent merge collapsed cost color bgcolor ctx)

;*---------------------------------------------------------------------*/
;*    list->bb ...                                                     */
;*---------------------------------------------------------------------*/
(define (list->bb l)

   (define (err l)
      (error "list->bb" "bad block syntax" l))

   (define (false l)
      #f)
   
   (define (zero l)
      0)
   
   (define (get l key default)
      (let ((val (memq key l)))
	 (if (pair? val)
	     (cadr val)
	     (default l))))

   (define (get-ins l)
      (let loop ((l (cddr l)))
	 (cond
	    ((null? l) '())
	    ((not (keyword? (car l))) l)
	    (else (loop (cddr l))))))
	     

   (let* ((num (cadr l))
	  (preds (get l :preds err))
	  (succs (get l :succs err))
	  (ins (get-ins l))
	  (parent (get l :parent false))
	  (merge (get l :merge false))
	  (collapsed (get l :collapsed false))
	  (cost (get l :cost zero))
	  (color (get l :color (lambda (l) (get-color parent))))
	  (bgcolor (merge-bgcolor (get l :minfo (lambda (l) 'default))))
	  (ctx (get l :context false)))
      (bb num preds succs ins parent merge collapsed cost color bgcolor ctx)))

;*---------------------------------------------------------------------*/
;*    *colors* ...                                                     */
;*---------------------------------------------------------------------*/
(define *colors* '((0 . "#999999")))

;*---------------------------------------------------------------------*/
;*    merge-bgcolor ...                                                */
;*---------------------------------------------------------------------*/
(define (merge-bgcolor minfo)
   (case minfo
      ((merge-target) "#95ff2d")
      ((merge-new) "#ffad3e")
      (else "grey85")))

;*---------------------------------------------------------------------*/
;*    get-color ...                                                    */
;*---------------------------------------------------------------------*/
(define (get-color num)
   (let ((col (assq num *colors*)))
      (if (pair? col)
	  (cdr col)
	  (let ((new (gennewcolor)))
	     (set! *colors* (cons (cons num new) *colors*))
	     new))))

;*---------------------------------------------------------------------*/
;*    rand ...                                                         */
;*    -------------------------------------------------------------    */
;*    A non random random generator (for reproducibility).             */
;*---------------------------------------------------------------------*/
(define (rand)
   (if (=fx cnt 1)
       (set! cnt (-fx (vector-length seed) 1))
       (set! cnt (-fx cnt 1)))
   (vector-ref seed cnt))

(define-macro (make-seed num)
   `',(list->vector (map (lambda (i) (random 155)) (iota num))))

(define seed (make-seed 1024))
(define cnt 1)

;*---------------------------------------------------------------------*/
;*    gennewcolor ...                                                  */
;*---------------------------------------------------------------------*/
(define (gennewcolor)
   (let ((r (+fx 100 (rand)))
	 (g (+fx 100 (rand)))
	 (b (+fx 100 (rand))))
      (format "#~02x~02x~02x" r g b)))

;*---------------------------------------------------------------------*/
;*    main ...                                                         */
;*---------------------------------------------------------------------*/
(define (dump-cfg name bbs)
   
   ;; For generating visual representation of control flow graph with "dot".
   
   (define nodes '())
   
   (define edges '())
   
   (define (add-node! node)
      (set! nodes (append node nodes)))
   
   (define (add-edge! from to dotted color)
      (set! edges (append (gen-edge from to dotted color) edges)))
   
   (define (gen-digraph name)
      `("digraph \"" ,name "\" {\n"
	  "  graph [splines = true overlap = false rankdir = \"TD\"];\n"
	  ,@nodes
	  ,@edges
	  "}\n"))
   
   (define (gen-node id label)
      `("  " ,id " [" ,fontsize " fontname = \"Courier New\" shape = \"none\" label = "
	  ,@label
	  " ];\n"))

   (define (gen-edge from to dotted? color)
      `(,from " -> " ,to
	  ,(cond
	      ((and dotted? color) (format " [style = dashed; color = ~a];\n" color))
	      (dotted? " [style = dotted];\n")
	      (color (format " [color = ~a];\n" color))
	      (else ";\n"))))
   
   (define (gen-table id content #!key (bgcolor "gray85") (color "black") (cellspacing 0))
      `("<table border=\"0\" cellborder=\"0\" cellspacing=\""
	  ,cellspacing
	  "\" cellpadding=\"0\""
	  ,@(if bgcolor (list (format " bgcolor=\"~a\"" bgcolor)) '())
	  ,@(if color (list (format " color=\"~a\"" color)) '())
	  ,@(if id (list (format " port=\"~a\"" id)) '())
	  ">"
	  ,@content
	  "</table>"))
   
   (define (gen-row content)
      `("<tr>" ,@content "</tr>"))
   
   (define (gen-col id content::pair #!key color)
      `("<td align=\"left\""
	  ,@(if id `(" port=\"" ,id "\"") '())
	  ,@(if color `(" color=\"" ,color "\"") '())
	  ">"
	  ,@content
	  "</td>"))
   
   (define (gen-head content::pair-nil)
      `("<td align=\"center\">" ,@content "</td>"))
   
   (define (gen-html-label content)
      `("<" ,@content ">"))

   (define (normalize-mov obj)
      (match-case obj
	 ((mov ?exp) exp)
	 ((?fun ?exp) `(,fun ,(normalize-mov exp)))
	 ((?- . ?-) (map normalize-mov obj))
	 (else obj)))
   
   (define (escape obj)
      (cond
	 ((string? obj)
	  (cond
	     ((string=? obj "<-")
	      "&larr;")
	     ((string=? obj "fail")
	      "<b><font color=\"red\">fail</font></b>")
	     (else
	      (apply string-append
		 (map (lambda (c)
			 (cond ((char=? c #\<) "&lt;")
			       ((char=? c #\>) "&gt;")
			       ((char=? c #\&) "&amp;")
			       (else (string c))))
		    (string->list obj))))))
	 ((symbol? obj)
	  (escape (symbol->string obj)))
	 ((pair? obj)
	  (let ((nobj (normalize-mov obj)))
	     (if (pair? nobj)
		 (format "(~( ))" (map escape nobj))
		 (escape nobj))))
	 ((string? obj)
	  obj)
	 (else
	  (format "~s" obj))))

   (define (jump? x)
      (and (pair? x) (memq (car x) '(ifne ifeq go))))

   (define (go? x)
      (and (pair? x) (pair? (car x)) (eq? (caar x) 'go)))

   (define (add-bb! bb)
      
      (define id (bb-lbl-num bb))
      (define port-count (-fx (length (bb-succs bb)) 1))
      (define rev-rows '())
      
      (define (add-row row)
	 (set! rev-rows (cons row rev-rows)))

      (define (add-ref! from side to dotted? color)
	 (if from
	     (add-edge! (format "~a:~a ~a" id from side) to dotted? color)
	     (add-edge! (format "~a ~a" id side) to dotted? color)))
      
      (define (getport code)
	 (when (jump? code)
	    (let ((port port-count))
	       (set! port-count (-fx port-count 1))
	       port)))

      (define (decorate-ctx-entry entry)
	 (match-case entry
	    (#(?reg ?type _ ())
	     (if compact
		 (format "~a:~(,)" (escape reg) type)
		 (format "~a:~a" (escape reg) type)))
	    (#(?reg ?type ?val ())
	     (if compact
		 (format "~a:~(,)/~a" (escape reg) type val)
		 (format "~a:~a/~a" (escape reg) type val)))
	    (#(?reg ?type ?val ?aliases)
	     (if compact
		 (format "~a:~(,)/~a" (escape reg) type val)
		 (format "~a:~a/~a[~( )]" (escape reg) type val (map escape aliases))))
	    (else
	     "-")))
      
      (define (decorate-ctx::pair-nil ins)
	 (if (pair? (cadr ins))
	     (let ((ctx (cadr ins)))
		(gen-row
		   (gen-col #f
		      (gen-table #f
			 (gen-row
			    (gen-col #f
			       (list (format "<font color=\"blue\"><i>~( )</i></font>"
					(map decorate-ctx-entry ctx)))))
			 :color "blue"
			 :bgcolor (bb-bgcolor bb)
			 :cellspacing 2))))
	     '()))

      (define (decorate-instr::pair ins last-instr?)
	 
	 (define (target-id ref)
	    (string->number (substring ref 1 (string-length ref))))
	 
	 (let ((code (car ins))
	       (ctx (cadr ins)))
	    (gen-row
	       (gen-col #f
		  (gen-table #f
		     (gen-row
			(gen-col (getport code)
			   (list (format "~( )" (map escape code)))))
		     :bgcolor (bb-bgcolor bb)
		     :cellspacing 2)))))
      
      (let* ((lbl (format "<b>#~a</b>" (bb-lbl-num bb)))
	     (title `(,(cond
			  ((bb-merge bb)
			   (format "<font color=\"green\">~a</font>"
			      lbl))
			  ((bb-collapsed bb)
			   (format "<font color=\"red\">~a!</font>"
			      lbl))
			  (else
			   lbl))
		      ,(if (bb-parent bb) (format "[~s]" (bb-parent bb)) "")))
	     (head (gen-row
		      (gen-col #f
			 (gen-table #f
			    (gen-row (gen-head title))
			    :bgcolor (bb-color bb)))))
	     (instrs (bb-instrs bb)))
	 (let loop ((instrs instrs)
		    (succs (reverse (bb-succs bb)))
		    (port (-fx (length (bb-succs bb)) 1)))
	    (when (pair? instrs)
	       (let ((ins (car instrs)))
		  (cond
		     ((not (pair? ins))
		      (loop (cdr instrs) succs port))
		     ((eq? (caar ins) 'go)
		      (add-ref! port ":sw" (car succs) #f "blue")
		      (loop (cdr instrs) (cdr succs) (-fx port 1)))
		     ((eq? (caar ins) 'ifne)
		      (add-ref! port ":e" (car succs) #f "green")
		      (loop (cdr instrs) (cdr succs) (-fx port 1)))
		     ((eq? (caar ins) 'ifeq)
		      (add-ref! port ":e" (car succs) #t "black")
		      (loop (cdr instrs) (cdr succs) (-fx port 1)))
		     (else
		      (loop (cdr instrs) succs port))))))
	 (when (and (pair? (bb-succs bb))
		    (or (null? instrs) (not (go? (car (last-pair instrs))))))
	    (add-ref! #f ":s" (car (bb-succs bb)) #f "red"))
	 (add-node!
	    (gen-node id
	       (gen-html-label
		  (gen-table #f
		     (append head
			(if (pair? (bb-ctx bb))
			    (gen-row
			       (gen-col #f
				  (gen-table #f
				     (gen-row
					(gen-col #f
					   (list (format "<font color=\"magenta4\"><i>~( )</i></font>"
						    (map decorate-ctx-entry (bb-ctx bb))))))
				     :bgcolor (bb-bgcolor bb)
				     :cellspacing 2)))
			    '())
			(let loop ((lst instrs))
			   (if (pair? lst)
			       (let ((rest (cdr lst)))
				  (append
				     (decorate-ctx (car lst))
				     (decorate-instr (car lst) (null? rest))
				     (loop rest)))
			       '())))))))))
   
   (for-each add-bb! (map list->bb (reverse bbs)))
   (for-each display (gen-digraph name)))

;*---------------------------------------------------------------------*/
;*    main ...                                                         */
;*---------------------------------------------------------------------*/
(define (main args)
   (let ((file #f))
      (args-parse (cdr args)
	 ((("-f" "--font") ?fs (help "font size"))
	  (set! fontsize (format "fontsize = ~a" fs)))
	 ((("-c" "--compact") (help "compact display"))
	  (set! compact #t))
	 (else
	  (set! file else)))
      (if (string? file)
	  (dump-cfg file
	     (call-with-input-file file port->sexp-list))
	  (dump-cfg "stdin"
	     (port->sexp-list (current-input-port))))))
