;*=====================================================================*/
;*    .../prgm/project/bigloo/bigloo/api/mqtt/src/Llib/server.scm      */
;*    -------------------------------------------------------------    */
;*    Author      :  Manuel Serrano                                    */
;*    Creation    :  Sun Mar 13 06:41:15 2022                          */
;*    Last change :  Tue Mar 29 10:32:00 2022 (serrano)                */
;*    Copyright   :  2022 Manuel Serrano                               */
;*    -------------------------------------------------------------    */
;*    MQTT server side                                                 */
;*=====================================================================*/

;*---------------------------------------------------------------------*/
;*    The module                                                       */
;*---------------------------------------------------------------------*/
(module __mqtt_server

   (library pthread)
   
   (import __mqtt_common)
   
   (export (class mqtt-server
	      (lock read-only (default (make-mutex "mqtt-server")))
	      (socket::socket read-only)
	      (subscriptions::pair-nil (default '()))
	      (retains::pair-nil (default '()))
	      (debug::long (default 0))
	      (on (default #f)))
	   
	   (class mqtt-client-conn
	      (sock::socket read-only)
	      (lock read-only (default (make-mutex "mqtt-server-conn")))
	      (version::long read-only)
	      (connpk::mqtt-connect-packet read-only))

	   (mqtt-make-server ::obj #!key (debug 0) (on #f))
	   (mqtt-server-loop ::mqtt-server)
	   (mqtt-read-server-packet ip::input-port ::long)))

;*---------------------------------------------------------------------*/
;*    topic ...                                                        */
;*---------------------------------------------------------------------*/
(define-struct topic name regexp qos)

;*---------------------------------------------------------------------*/
;*    flag? ...                                                        */
;*---------------------------------------------------------------------*/
(define (flag? flags flag)
   (=fx (bit-and flags flag) flag))

;*---------------------------------------------------------------------*/
;*    mqtt-make-server ...                                             */
;*---------------------------------------------------------------------*/
(define (mqtt-make-server socket #!key (debug 0) (on #f))
   (when (and on (not (and (procedure? on) (correct-arity? on 2))))
      (error "mqtt-make-server" "wrong event listener" on))
   (instantiate::mqtt-server
      (socket socket)
      (debug debug)
      (on on)))

;*---------------------------------------------------------------------*/
;*    mqtt-server-loop ...                                             */
;*---------------------------------------------------------------------*/
(define (mqtt-server-loop srv::mqtt-server)
   (with-access::mqtt-server srv (socket)
      (unwind-protect
	 (let loop ()
	    (let* ((sock (socket-accept socket))
		   (pk (mqtt-read-connect-packet (socket-input sock))))
	       (when (isa? pk mqtt-connect-packet)
		  (with-access::mqtt-connect-packet pk (version client-id flags)
		     (let ((conn (instantiate::mqtt-client-conn
				    (sock sock)
				    (version version)
				    (connpk pk))))
			(mqtt-conn-loop srv conn))))
	       (loop)))
	 (mqtt-server-close srv))))

;*---------------------------------------------------------------------*/
;*    mqtt-server-close ...                                            */
;*---------------------------------------------------------------------*/
(define (mqtt-server-close srv::mqtt-server)
   (with-access::mqtt-server srv (socket lock)
      #f))

;*---------------------------------------------------------------------*/
;*    mqtt-server-debug ...                                            */
;*---------------------------------------------------------------------*/
(define-macro (mqtt-server-debug srv thunk)
   `(with-access::mqtt-server ,srv (debug)
       (when (>fx debug 0)
	  (,thunk))))

;*---------------------------------------------------------------------*/
;*    mqtt-conn-loop ...                                               */
;*---------------------------------------------------------------------*/
(define (mqtt-conn-loop srv::mqtt-server conn::mqtt-client-conn)
   (with-access::mqtt-client-conn conn (sock lock version connpk)
      (with-access::mqtt-connect-packet connpk (client-id)
	 (with-access::mqtt-server srv (on)
	    (when on (on "connection" client-id))
	    (mqtt-server-debug srv
	       (lambda ()
		  (tprint "New client connected as " client-id)
		  (tprint "sending CONNACK to " client-id)))))
      (mqtt-write-connack-packet (socket-output sock) 0)
      (thread-start!
	 (instantiate::pthread
	    (name "mqtt-server-loop")
	    (body (lambda ()
		     (let ((ip (socket-input sock))
			   (op (socket-output sock)))
			(let loop ()
			   (let ((pk (mqtt-read-server-packet ip version)))
			      (if (not (isa? pk mqtt-control-packet))
				  (mqtt-server-will srv conn)
				  (with-access::mqtt-control-packet pk (type)
				     (mqtt-server-debug srv
					(lambda ()
					   (with-access::mqtt-connect-packet connpk (client-id)
					      (tprint "Received "
						 (mqtt-control-packet-type-name type)
						 " from " client-id))))
				     (cond
					((=fx type (MQTT-CPT-CONNECT))
					 ;; 3.1, error
					 (mqtt-server-will srv conn)
					 #f)
					((=fx type (MQTT-CPT-PUBLISH))
					 ;; 3.3
					 (mqtt-server-publish srv pk)
					 (loop))
					((=fx type (MQTT-CPT-PUBACK))
					 ;; 3.4
					 (loop))
					((=fx type (MQTT-CPT-PUBREC))
					 ;; 3.5
					 (loop))
					((=fx type (MQTT-CPT-SUBSCRIBE))
					 ;; 3.8
					 (mqtt-server-subscribe srv conn pk)
					 (loop))
					((=fx type (MQTT-CPT-UNSUBSCRIBE))
					 ;; 3.10
					 (mqtt-server-unsubscribe srv conn pk)
					 (loop))
					((=fx type (MQTT-CPT-PINGREQ))
					 ;; 3.12
					 (mqtt-write-pingresp-packet op)
					 (loop))
					((=fx type (MQTT-CPT-DISCONNECT))
					 ;; 3.14
					 #unspecified)
					(else
					 (loop)))))))
			(socket-close sock))))))))

;*---------------------------------------------------------------------*/
;*    mqtt-server-will ...                                             */
;*---------------------------------------------------------------------*/
(define (mqtt-server-will srv::mqtt-server conn::mqtt-client-conn)
   (with-access::mqtt-client-conn conn (connpk)
      (with-access::mqtt-connect-packet connpk (flags will-topic will-message)
	 (when (flag? flags (MQTT-CONFLAG-WILL-FLAG))
	    (let* ((flags (if (flag? flags (MQTT-CONFLAG-WILL-RETAIN))
			      1 0))
		   (qos (bit-rsh
			   (bit-or
			      (bit-and flags (MQTT-CONFLAG-WILL-QOSL))
			      (bit-and flags (MQTT-CONFLAG-WILL-QOSH)))
			   3))
		   (pk (instantiate::mqtt-publish-packet
			  (type (MQTT-CPT-PUBLISH))
			  (topic will-topic)
			  (flags flags)
			  (qos qos)
			  (payload will-message))))
	       (mqtt-server-publish srv pk))))))

;*---------------------------------------------------------------------*/
;*    mqtt-server-publish ...                                          */
;*---------------------------------------------------------------------*/
(define (mqtt-server-publish srv::mqtt-server pk::mqtt-publish-packet)
   (with-trace 'mqtt "mqtt-server-publish"
      (with-access::mqtt-server srv (lock subscriptions retains on)
	 (with-access::mqtt-publish-packet pk (flags topic)
	    (mqtt-server-debug srv
	       (lambda ()
		  (with-access::mqtt-publish-packet pk (topic)
		     (tprint "Publish " topic))))
	    (when on (on "publish" topic))
	    (when (=fx (bit-and flags 1) 1)
	       ;; 3.3.1.3 RETAIN
	       (synchronize lock
		  (set! retains (cons pk retains))))
	    (for-each (lambda (subscription)
			 (mqtt-conn-publish subscription pk))
	       subscriptions)))))

;*---------------------------------------------------------------------*/
;*    mqtt-conn-publish ...                                            */
;*---------------------------------------------------------------------*/
(define (mqtt-conn-publish subscription::pair pk::mqtt-publish-packet)
   (with-trace 'mqtt "mqtt-conn-publish"
      (with-access::mqtt-publish-packet pk (topic payload)
	 (let ((conn (car subscription))
	       (topics (cdr subscription)))
	    (for-each (lambda (t)
			 (when (mqtt-topic-match? (topic-regexp t) topic)
			    (with-access::mqtt-client-conn conn (sock)
			       (mqtt-write-publish-packet
				  (socket-output sock)
				  #f 0 #f topic 0 payload))))
	       topics)))))

;*---------------------------------------------------------------------*/
;*    mqtt-server-subscribe ...                                        */
;*---------------------------------------------------------------------*/
(define (mqtt-server-subscribe srv::mqtt-server conn pk::mqtt-control-packet)
   
   (define (payload->topic payload)
      (topic (car payload)
	 (topic-filter->regexp (car payload))
	 (cdr payload)))
   
   (with-trace 'mqtt "mqtt-server-subscribe"
      (with-access::mqtt-server srv (lock subscriptions retains)
	 (synchronize lock
	    (with-access::mqtt-control-packet pk (payload)
	       (mqtt-server-debug srv
		  (lambda ()
		     (tprint "Subscribe " payload)))
	       (let ((cell (assq conn subscriptions)))
		  (if (not cell)
		      (set! subscriptions
			 (cons (cons conn (map payload->topic payload))
			    subscriptions))
		      (for-each (lambda (payload)
				   (unless (find (lambda (t)
						    (string=? (topic-name t)
						       (car payload)))
					      (cdr cell))
				      (set-cdr! cell
					 (cons (payload->topic payload)
					    (cdr cell)))))
			 payload)))))
	 (for-each (lambda (pk)
		      (mqtt-server-publish srv pk))
	    retains))))

;*---------------------------------------------------------------------*/
;*    mqtt-server-unsubscribe ...                                      */
;*---------------------------------------------------------------------*/
(define (mqtt-server-unsubscribe srv::mqtt-server conn pk::mqtt-control-packet)
   (with-trace 'mqtt "mqtt-server-unsubscribe"
      (with-access::mqtt-server srv (lock subscriptions)
	 (with-access::mqtt-control-packet pk (payload pid)
	    (synchronize lock
	       (let ((cell (assq conn subscriptions)))
		  (when (pair? cell)
		     (set-cdr! cell
			(filter! (lambda (topic)
				    (not (member (topic-name topic) payload)))
			   (cdr cell))))))
	    (with-access::mqtt-client-conn conn (sock)
	       ;; 3.10.4 Response
	       (mqtt-write-unsuback-packet (socket-output sock) pid))))))

;*---------------------------------------------------------------------*/
;*    mqtt-read-server-packet ...                                      */
;*---------------------------------------------------------------------*/
(define (mqtt-read-server-packet ip::input-port version::long)
   (with-trace 'mqtt "mqtt-read-server-packet"
      (let ((header (read-byte ip)))
	 (if (eof-object? header)
	     header
	     (let ((ptype (bit-rsh header 4)))
		(trace-item "type=" (mqtt-control-packet-type-name ptype))
		(unread-char! (integer->char header) ip)
		(cond
		   ((=fx ptype (MQTT-CPT-CONNECT))
		    (mqtt-read-connect-packet ip))
		   ((=fx ptype (MQTT-CPT-PUBLISH))
		    (mqtt-read-publish-packet ip version))
		   ((=fx ptype (MQTT-CPT-SUBSCRIBE))
		    (mqtt-read-subscribe-packet ip version))
		   ((=fx ptype (MQTT-CPT-UNSUBSCRIBE))
		    (mqtt-read-unsubscribe-packet ip version))
		   ((=fx ptype (MQTT-CPT-PUBREC))
		    (mqtt-read-pubrec-packet ip version))
		   ((=fx ptype (MQTT-CPT-PINGREQ))
		    (mqtt-read-pingreq-packet ip version))
		   ((=fx ptype (MQTT-CPT-DISCONNECT))
		    (mqtt-read-disconnect-packet ip version))
		   (else
		    (error "mqtt:server" "Illegal packet type"
		       (mqtt-control-packet-type-name ptype)))))))))
