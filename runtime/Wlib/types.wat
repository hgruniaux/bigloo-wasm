(module $__types
   
   (type $cnst-table (array (mut (ref eq))))
   
   (type $vector (array (mut (ref eq))))
   (type $dvector (array (mut f64)))
   (type $lvector (array (mut i64)))
   (type $bvector (array (mut i32)))
   (type $s8vector (array (mut i8)))
   (type $s16vector (array (mut i16)))
   (type $s32vector (array (mut i32)))
   (type $s64vector (array (mut i64)))
   (type $u8vector (array (mut i8)))
   (type $u16vector (array (mut i16)))
   (type $u32vector (array (mut i32)))
   (type $u64vector (array (mut i64)))
   (type $f32vector (array (mut f32)))
   (type $f64vector (array (mut f64)))
   
   (type $procedure (struct 
		       (field $entry (ref func))
		       (field $attr (mut (ref eq)))
		       (field $arity i32)
		       (field $env (ref null $vector))))
   ;;(type $tmpfun (struct (field (ref func))))

   (type $procedure-l (struct
			 (field $entry (ref func))
			 (field $env (ref null $vector))))
   (type $procedure-el (array (mut (ref eq))))
   
   (tag $fail)
   
   ;; Boxed string
   (rec (type $bstring (array (mut i8))))
   (rec (type $ucs2string (array (mut i16))))
   
   (type $regexp (struct))

   (type $opaque (struct))
   
   ;; TODO
   (rec
      (type $pair-nil (struct))
      (type $symbol
	 (struct (field $str (ref $bstring)) (field $cval (mut (ref eq)))))
      (type $keyword
	 (struct (field $str (ref $bstring)) (field $cval (mut (ref eq)))))
      (type $custom (struct (field $ident (mut (ref $bstring)))))
      (type $weakptr (struct)))
   
   ;; Functions types (for closures and variadic calls)
   (type $func0 (func (param (ref $procedure)) (result (ref eq))))
   (type $func1 (func (param (ref $procedure)) (param (ref eq)) (result (ref eq))))
   (type $func2 (func (param (ref $procedure)) (param (ref eq) (ref eq)) (result (ref eq))))
   (type $func3 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func4 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func5 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func6 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func7 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func8 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func9 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func10 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func11 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func12 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func13 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func14 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func15 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func16 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func17 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func18 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func19 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func20 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))
   (type $func21 (func (param (ref $procedure)) (param (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq) (ref eq)) (result (ref eq))))

   ;; cells
   (type $cell (struct (field $val (mut (ref eq)))))
   
   ;; Pairs
   (rec
      (type $pair (sub (struct
			  (field $car (mut (ref eq)))
			  (field $cdr (mut (ref eq))))))
      (type $epair (sub $pair (struct 
				 (field $car (mut (ref eq))) 
				 (field $cdr (mut (ref eq))) 
				 (field $cer (mut (ref eq)))))))
   
   ;; Bignums
   (type $bignum
      (struct (field $bx externref)))
   
   ;; Boxed numeric types
   (rec
      ;; (type $bbool (struct (field $v i8)))
      ;; (type $bchar (struct (field $v i8)))
      (type $bucs2 (struct (field $v i16)))
      (type $bint8 (struct (field $v i8)))
      (type $buint8 (struct (field $v i8)))
      (type $bint16 (struct (field $v i16)))
      (type $buint16 (struct (field $v i16)))
      (type $bint32 (struct (field $v i32)))
      (type $buint32 (struct (field $v i32)))
      (type $bint64 (struct (field $v i64)))
      (type $buint64 (struct (field $v i64)))
      (type $bint (struct (field $v i64)))
      (type $buint (struct (field $v i64)))
      (type $belong (struct (field $v i64)))
      (type $bllong (struct (field $v i64)))
      (type $real (struct (field $v f64))))

   (rec (type $exit (struct 
		       (field $userp (mut i64))
		       (field $stamp (mut i64))
		       (field $protect (mut (ref eq)))
		       (field $prev (mut (ref null $exit))))))
   (tag $bexception (param (ref $exit)) (param anyref))
   
   ;; Exception raised for unimplemented code.
   (tag $unimplemented)
   
   ;; Classes
   (type $class (struct
		   (field $name (ref $symbol))
		   (field $module (ref $symbol))
		   (field $new_fun (ref eq))
		   (field $alloc_fun (ref $procedure))
		   (field $nil_fun (ref $procedure))
		   (field $nil (ref eq))
		   (field $constructor (ref eq))
		   (field $super (ref eq))
		   (field $subclasses (mut (ref eq)))
		   (field $shrink (ref eq))
		   (field $evdata (mut (ref eq)))
		   (field $ancestors (ref $vector))
		   (field $virtual_fields (ref $vector))
		   (field $direct_fields (mut (ref $vector)))
		   (field $all_fields (mut (ref $vector)))
		   (field $hash i64)
		   (field $index i64)
		   (field $depth i64)))
   
   (type $struct (struct
		    (field $key (ref eq))
		    (field $values (ref $vector))))
   
   (type $BgL_objectz00_bglt (sub (struct
				     (field $header (mut i64))
				     (field $widening (mut (ref eq))))))
   
  ;; Ports
   (type $port (sub
		  (struct
		     (field $name (mut (ref $bstring)))
		     (field $chook (mut (ref eq))))))

   (type $output-port (sub $port
			 (struct
			    (field $name (mut (ref $bstring)))
			    (field $chook (mut (ref eq)))
			    (field $buffer (mut (ref $bstring)))
			    (field $index (mut i32))
			    (field $fhook (mut (ref eq)))
			    (field $flushbuf (mut (ref eq)))
			    (field $isclosed (mut i32)))))
   (type $file-output-port (sub final $output-port
			      (struct
				 (field $name (mut (ref $bstring)))
				 (field $chook (mut (ref eq)))
				 (field $buffer (mut (ref $bstring)))
				 (field $index (mut i32))
				 (field $fhook (mut (ref eq)))
				 (field $flushbuf (mut (ref eq)))
				 (field $isclosed (mut i32))
				 (field $fd i32))))
   (type $string-output-port (sub final $output-port
				(struct
				   (field $name (mut (ref $bstring)))
				   (field $chook (mut (ref eq)))
				   (field $buffer (mut (ref $bstring)))
				   (field $index (mut i32))
				   (field $fhook (mut (ref eq)))
				   (field $flushbuf (mut (ref eq)))
				   (field $isclosed (mut i32)))))
   
   (type $rgc (struct
		 ;; We only uses i32 as arrays can only be indexed by 32 bits integers.
		 (field $eof (mut i32))
		 (field $filepos (mut i32))
		 (field $forward (mut i32))
		 (field $bufpos (mut i32))
		 (field $matchstart (mut i32))
		 (field $matchstop (mut i32))
		 (field $lastchar (mut i32))
		 (field $buffer (mut (ref $bstring)))))
   
   (type $input-port (sub $port
			(struct
			   (field $name (mut (ref $bstring)))
			   (field $chook (mut (ref eq)))
			   (field $rgc (ref $rgc))
			   (field $isclosed (mut i32)))))
   
   (type $file-input-port (sub $input-port
			     (struct
				(field $name (mut (ref $bstring)))
				(field $chook (mut (ref eq)))
				(field $rgc (ref $rgc))
				(field $isclosed (mut i32))
				(field $fd i32))))
   
   (type $binary-port (sub (struct)))
   
   ;; Foreign type
   (rec (type $cobj (struct)))
   (type $foreign (struct
		     (field $id (ref $symbol))
		     (field $ptr i32)))
   
   ;; Date type
   (type $date (struct
		  (field $timezone (mut i64))
		  (field $year (mut i32))
		  (field $month (mut i32))
		  (field $yday (mut i32))
		  (field $wday (mut i32))
		  (field $day (mut i32))
		  (field $hour (mut i32))
		  (field $minute (mut i32))
		  (field $second (mut i32))
		  (field $nanosecond (mut i64))
		  (field $is-dst (mut i32))
		  (field $is-gmt (mut i32))
		  (field $time (mut i64))))
   
   ;; Thread types
   (type $mutex (struct
		   (field $name (ref eq))
		   (field $backend (ref eq))
		   (field $state (ref eq))))
   (type $condvar (struct))
   (type $semaphore (struct))
   
   ;; Network
   (type $socket (struct))
   (type $datagram-socket (struct))
   
   (type $process (struct))
   (type $mmap (struct))
   
   (type $tvector (struct))
   (type $hvector (struct))
   
   ;; Dynamic env (for multithreading)
   (type $dynamic-env
      (struct 
	 (field $exitd_top (mut (ref $exit)))
	 (field $exitd_val (mut (ref eq)))
	 (field $uncaught-exception-handler (mut (ref eq)))
	 (field $error-handler (mut (ref eq)))
	 
	 (field $current-output-port (mut (ref $output-port)))
	 (field $current-error-port (mut (ref $output-port)))
	 (field $current-input-port (mut (ref $input-port)))

	 (field $module (mut (ref eq)))
	 (field $abase (mut (ref eq)))))
   )
