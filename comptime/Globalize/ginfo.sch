;; ==========================================================
;; Class accessors
;; Bigloo (4.6a)
;; Inria -- Sophia Antipolis     Thu Aug 29 03:10:46 PM CEST 2024 
;; (bigloo -classgen Globalize/ginfo.scm)
;; ==========================================================

;; The directives
(directives

;; sfun/Ginfo
(cond-expand ((and bigloo-class-sans (not bigloo-class-generate))
  (export
    (inline make-sfun/Ginfo::sfun/Ginfo arity1277::long side-effect1278::obj predicate-of1279::obj stack-allocator1280::obj top?1281::bool the-closure1282::obj effect1283::obj failsafe1284::obj args-noescape1285::obj args-retescape1286::obj property1287::obj args1288::obj args-name1289::obj body1290::obj class1291::obj dsssl-keywords1292::obj loc1293::obj optionals1294::obj keys1295::obj the-closure-global1296::obj strength1297::symbol stackable1298::obj G?1299::bool cfrom1300::obj cfrom*1301::obj cto1302::obj cto*1303::obj efunctions1304::obj integrator1305::obj imark1306::obj owner1307::obj integrated1308::obj plugged-in1309::obj mark1310::long free-mark1311::obj the-global1312::obj kaptured1313::obj new-body1314::obj bmark1315::long umark1316::long free1317::obj bound1318::obj)
    (inline sfun/Ginfo?::bool ::obj)
    (sfun/Ginfo-nil::sfun/Ginfo)
    (inline sfun/Ginfo-bound::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-bound-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-free::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-free-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-umark::long ::sfun/Ginfo)
    (inline sfun/Ginfo-umark-set! ::sfun/Ginfo ::long)
    (inline sfun/Ginfo-bmark::long ::sfun/Ginfo)
    (inline sfun/Ginfo-bmark-set! ::sfun/Ginfo ::long)
    (inline sfun/Ginfo-new-body::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-new-body-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-kaptured::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-kaptured-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-the-global::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-the-global-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-free-mark::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-free-mark-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-mark::long ::sfun/Ginfo)
    (inline sfun/Ginfo-mark-set! ::sfun/Ginfo ::long)
    (inline sfun/Ginfo-plugged-in::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-plugged-in-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-integrated::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-integrated-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-owner::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-owner-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-imark::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-imark-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-integrator::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-integrator-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-efunctions::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-efunctions-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-cto*::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-cto*-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-cto::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-cto-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-cfrom*::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-cfrom*-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-cfrom::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-cfrom-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-G?::bool ::sfun/Ginfo)
    (inline sfun/Ginfo-G?-set! ::sfun/Ginfo ::bool)
    (inline sfun/Ginfo-stackable::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-stackable-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-strength::symbol ::sfun/Ginfo)
    (inline sfun/Ginfo-strength-set! ::sfun/Ginfo ::symbol)
    (inline sfun/Ginfo-the-closure-global::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-the-closure-global-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-keys::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-optionals::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-loc::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-loc-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-dsssl-keywords::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-dsssl-keywords-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-class::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-class-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-body::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-body-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-args-name::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-args::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-args-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-property::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-property-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-args-retescape::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-args-retescape-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-args-noescape::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-args-noescape-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-failsafe::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-failsafe-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-effect::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-effect-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-the-closure::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-the-closure-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-top?::bool ::sfun/Ginfo)
    (inline sfun/Ginfo-top?-set! ::sfun/Ginfo ::bool)
    (inline sfun/Ginfo-stack-allocator::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-stack-allocator-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-predicate-of::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-predicate-of-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-side-effect::obj ::sfun/Ginfo)
    (inline sfun/Ginfo-side-effect-set! ::sfun/Ginfo ::obj)
    (inline sfun/Ginfo-arity::long ::sfun/Ginfo))))

;; svar/Ginfo
(cond-expand ((and bigloo-class-sans (not bigloo-class-generate))
  (export
    (inline make-svar/Ginfo::svar/Ginfo loc1270::obj kaptured?1271::bool free-mark1272::long mark1273::long celled?1274::bool stackable1275::bool)
    (inline svar/Ginfo?::bool ::obj)
    (svar/Ginfo-nil::svar/Ginfo)
    (inline svar/Ginfo-stackable::bool ::svar/Ginfo)
    (inline svar/Ginfo-stackable-set! ::svar/Ginfo ::bool)
    (inline svar/Ginfo-celled?::bool ::svar/Ginfo)
    (inline svar/Ginfo-celled?-set! ::svar/Ginfo ::bool)
    (inline svar/Ginfo-mark::long ::svar/Ginfo)
    (inline svar/Ginfo-mark-set! ::svar/Ginfo ::long)
    (inline svar/Ginfo-free-mark::long ::svar/Ginfo)
    (inline svar/Ginfo-free-mark-set! ::svar/Ginfo ::long)
    (inline svar/Ginfo-kaptured?::bool ::svar/Ginfo)
    (inline svar/Ginfo-kaptured?-set! ::svar/Ginfo ::bool)
    (inline svar/Ginfo-loc::obj ::svar/Ginfo)
    (inline svar/Ginfo-loc-set! ::svar/Ginfo ::obj))))

;; sexit/Ginfo
(cond-expand ((and bigloo-class-sans (not bigloo-class-generate))
  (export
    (inline make-sexit/Ginfo::sexit/Ginfo handler1263::obj detached?1264::bool G?1265::bool kaptured?1266::bool free-mark1267::long mark1268::long)
    (inline sexit/Ginfo?::bool ::obj)
    (sexit/Ginfo-nil::sexit/Ginfo)
    (inline sexit/Ginfo-mark::long ::sexit/Ginfo)
    (inline sexit/Ginfo-mark-set! ::sexit/Ginfo ::long)
    (inline sexit/Ginfo-free-mark::long ::sexit/Ginfo)
    (inline sexit/Ginfo-free-mark-set! ::sexit/Ginfo ::long)
    (inline sexit/Ginfo-kaptured?::bool ::sexit/Ginfo)
    (inline sexit/Ginfo-kaptured?-set! ::sexit/Ginfo ::bool)
    (inline sexit/Ginfo-G?::bool ::sexit/Ginfo)
    (inline sexit/Ginfo-G?-set! ::sexit/Ginfo ::bool)
    (inline sexit/Ginfo-detached?::bool ::sexit/Ginfo)
    (inline sexit/Ginfo-detached?-set! ::sexit/Ginfo ::bool)
    (inline sexit/Ginfo-handler::obj ::sexit/Ginfo)
    (inline sexit/Ginfo-handler-set! ::sexit/Ginfo ::obj))))

;; local/Ginfo
(cond-expand ((and bigloo-class-sans (not bigloo-class-generate))
  (export
    (inline make-local/Ginfo::local/Ginfo id1247::symbol name1248::obj type1249::type value1250::value access1251::obj fast-alpha1252::obj removable1253::obj occurrence1254::long occurrencew1255::long user?1256::bool key1257::long val-noescape1258::obj volatile1259::bool escape?1260::bool globalized?1261::bool)
    (inline local/Ginfo?::bool ::obj)
    (local/Ginfo-nil::local/Ginfo)
    (inline local/Ginfo-globalized?::bool ::local/Ginfo)
    (inline local/Ginfo-globalized?-set! ::local/Ginfo ::bool)
    (inline local/Ginfo-escape?::bool ::local/Ginfo)
    (inline local/Ginfo-escape?-set! ::local/Ginfo ::bool)
    (inline local/Ginfo-volatile::bool ::local/Ginfo)
    (inline local/Ginfo-volatile-set! ::local/Ginfo ::bool)
    (inline local/Ginfo-val-noescape::obj ::local/Ginfo)
    (inline local/Ginfo-val-noescape-set! ::local/Ginfo ::obj)
    (inline local/Ginfo-key::long ::local/Ginfo)
    (inline local/Ginfo-user?::bool ::local/Ginfo)
    (inline local/Ginfo-user?-set! ::local/Ginfo ::bool)
    (inline local/Ginfo-occurrencew::long ::local/Ginfo)
    (inline local/Ginfo-occurrencew-set! ::local/Ginfo ::long)
    (inline local/Ginfo-occurrence::long ::local/Ginfo)
    (inline local/Ginfo-occurrence-set! ::local/Ginfo ::long)
    (inline local/Ginfo-removable::obj ::local/Ginfo)
    (inline local/Ginfo-removable-set! ::local/Ginfo ::obj)
    (inline local/Ginfo-fast-alpha::obj ::local/Ginfo)
    (inline local/Ginfo-fast-alpha-set! ::local/Ginfo ::obj)
    (inline local/Ginfo-access::obj ::local/Ginfo)
    (inline local/Ginfo-access-set! ::local/Ginfo ::obj)
    (inline local/Ginfo-value::value ::local/Ginfo)
    (inline local/Ginfo-value-set! ::local/Ginfo ::value)
    (inline local/Ginfo-type::type ::local/Ginfo)
    (inline local/Ginfo-type-set! ::local/Ginfo ::type)
    (inline local/Ginfo-name::obj ::local/Ginfo)
    (inline local/Ginfo-name-set! ::local/Ginfo ::obj)
    (inline local/Ginfo-id::symbol ::local/Ginfo))))

;; global/Ginfo
(cond-expand ((and bigloo-class-sans (not bigloo-class-generate))
  (export
    (inline make-global/Ginfo::global/Ginfo id1224::symbol name1225::obj type1226::type value1227::value access1228::obj fast-alpha1229::obj removable1230::obj occurrence1231::long occurrencew1232::long user?1233::bool module1234::symbol import1235::obj evaluable?1236::bool eval?1237::bool library1238::obj pragma1239::obj src1240::obj qualified-type-name1241::bstring init1242::obj alias1243::obj escape?1244::bool global-closure1245::obj)
    (inline global/Ginfo?::bool ::obj)
    (global/Ginfo-nil::global/Ginfo)
    (inline global/Ginfo-global-closure::obj ::global/Ginfo)
    (inline global/Ginfo-global-closure-set! ::global/Ginfo ::obj)
    (inline global/Ginfo-escape?::bool ::global/Ginfo)
    (inline global/Ginfo-escape?-set! ::global/Ginfo ::bool)
    (inline global/Ginfo-alias::obj ::global/Ginfo)
    (inline global/Ginfo-alias-set! ::global/Ginfo ::obj)
    (inline global/Ginfo-init::obj ::global/Ginfo)
    (inline global/Ginfo-init-set! ::global/Ginfo ::obj)
    (inline global/Ginfo-qualified-type-name::bstring ::global/Ginfo)
    (inline global/Ginfo-qualified-type-name-set! ::global/Ginfo ::bstring)
    (inline global/Ginfo-src::obj ::global/Ginfo)
    (inline global/Ginfo-src-set! ::global/Ginfo ::obj)
    (inline global/Ginfo-pragma::obj ::global/Ginfo)
    (inline global/Ginfo-pragma-set! ::global/Ginfo ::obj)
    (inline global/Ginfo-library::obj ::global/Ginfo)
    (inline global/Ginfo-library-set! ::global/Ginfo ::obj)
    (inline global/Ginfo-eval?::bool ::global/Ginfo)
    (inline global/Ginfo-eval?-set! ::global/Ginfo ::bool)
    (inline global/Ginfo-evaluable?::bool ::global/Ginfo)
    (inline global/Ginfo-evaluable?-set! ::global/Ginfo ::bool)
    (inline global/Ginfo-import::obj ::global/Ginfo)
    (inline global/Ginfo-import-set! ::global/Ginfo ::obj)
    (inline global/Ginfo-module::symbol ::global/Ginfo)
    (inline global/Ginfo-module-set! ::global/Ginfo ::symbol)
    (inline global/Ginfo-user?::bool ::global/Ginfo)
    (inline global/Ginfo-user?-set! ::global/Ginfo ::bool)
    (inline global/Ginfo-occurrencew::long ::global/Ginfo)
    (inline global/Ginfo-occurrencew-set! ::global/Ginfo ::long)
    (inline global/Ginfo-occurrence::long ::global/Ginfo)
    (inline global/Ginfo-occurrence-set! ::global/Ginfo ::long)
    (inline global/Ginfo-removable::obj ::global/Ginfo)
    (inline global/Ginfo-removable-set! ::global/Ginfo ::obj)
    (inline global/Ginfo-fast-alpha::obj ::global/Ginfo)
    (inline global/Ginfo-fast-alpha-set! ::global/Ginfo ::obj)
    (inline global/Ginfo-access::obj ::global/Ginfo)
    (inline global/Ginfo-access-set! ::global/Ginfo ::obj)
    (inline global/Ginfo-value::value ::global/Ginfo)
    (inline global/Ginfo-value-set! ::global/Ginfo ::value)
    (inline global/Ginfo-type::type ::global/Ginfo)
    (inline global/Ginfo-type-set! ::global/Ginfo ::type)
    (inline global/Ginfo-name::obj ::global/Ginfo)
    (inline global/Ginfo-name-set! ::global/Ginfo ::obj)
    (inline global/Ginfo-id::symbol ::global/Ginfo)))))

;; The definitions
(cond-expand (bigloo-class-sans
;; sfun/Ginfo
(define-inline (make-sfun/Ginfo::sfun/Ginfo arity1277::long side-effect1278::obj predicate-of1279::obj stack-allocator1280::obj top?1281::bool the-closure1282::obj effect1283::obj failsafe1284::obj args-noescape1285::obj args-retescape1286::obj property1287::obj args1288::obj args-name1289::obj body1290::obj class1291::obj dsssl-keywords1292::obj loc1293::obj optionals1294::obj keys1295::obj the-closure-global1296::obj strength1297::symbol stackable1298::obj G?1299::bool cfrom1300::obj cfrom*1301::obj cto1302::obj cto*1303::obj efunctions1304::obj integrator1305::obj imark1306::obj owner1307::obj integrated1308::obj plugged-in1309::obj mark1310::long free-mark1311::obj the-global1312::obj kaptured1313::obj new-body1314::obj bmark1315::long umark1316::long free1317::obj bound1318::obj) (instantiate::sfun/Ginfo (arity arity1277) (side-effect side-effect1278) (predicate-of predicate-of1279) (stack-allocator stack-allocator1280) (top? top?1281) (the-closure the-closure1282) (effect effect1283) (failsafe failsafe1284) (args-noescape args-noescape1285) (args-retescape args-retescape1286) (property property1287) (args args1288) (args-name args-name1289) (body body1290) (class class1291) (dsssl-keywords dsssl-keywords1292) (loc loc1293) (optionals optionals1294) (keys keys1295) (the-closure-global the-closure-global1296) (strength strength1297) (stackable stackable1298) (G? G?1299) (cfrom cfrom1300) (cfrom* cfrom*1301) (cto cto1302) (cto* cto*1303) (efunctions efunctions1304) (integrator integrator1305) (imark imark1306) (owner owner1307) (integrated integrated1308) (plugged-in plugged-in1309) (mark mark1310) (free-mark free-mark1311) (the-global the-global1312) (kaptured kaptured1313) (new-body new-body1314) (bmark bmark1315) (umark umark1316) (free free1317) (bound bound1318)))
(define-inline (sfun/Ginfo?::bool obj::obj) ((@ isa? __object) obj (@ sfun/Ginfo globalize_ginfo)))
(define (sfun/Ginfo-nil::sfun/Ginfo) (class-nil (@ sfun/Ginfo globalize_ginfo)))
(define-inline (sfun/Ginfo-bound::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o bound))
(define-inline (sfun/Ginfo-bound-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o bound) v))
(define-inline (sfun/Ginfo-free::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o free))
(define-inline (sfun/Ginfo-free-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o free) v))
(define-inline (sfun/Ginfo-umark::long o::sfun/Ginfo) (-> |#!bigloo_wallow| o umark))
(define-inline (sfun/Ginfo-umark-set! o::sfun/Ginfo v::long) (set! (-> |#!bigloo_wallow| o umark) v))
(define-inline (sfun/Ginfo-bmark::long o::sfun/Ginfo) (-> |#!bigloo_wallow| o bmark))
(define-inline (sfun/Ginfo-bmark-set! o::sfun/Ginfo v::long) (set! (-> |#!bigloo_wallow| o bmark) v))
(define-inline (sfun/Ginfo-new-body::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o new-body))
(define-inline (sfun/Ginfo-new-body-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o new-body) v))
(define-inline (sfun/Ginfo-kaptured::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o kaptured))
(define-inline (sfun/Ginfo-kaptured-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o kaptured) v))
(define-inline (sfun/Ginfo-the-global::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o the-global))
(define-inline (sfun/Ginfo-the-global-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o the-global) v))
(define-inline (sfun/Ginfo-free-mark::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o free-mark))
(define-inline (sfun/Ginfo-free-mark-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o free-mark) v))
(define-inline (sfun/Ginfo-mark::long o::sfun/Ginfo) (-> |#!bigloo_wallow| o mark))
(define-inline (sfun/Ginfo-mark-set! o::sfun/Ginfo v::long) (set! (-> |#!bigloo_wallow| o mark) v))
(define-inline (sfun/Ginfo-plugged-in::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o plugged-in))
(define-inline (sfun/Ginfo-plugged-in-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o plugged-in) v))
(define-inline (sfun/Ginfo-integrated::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o integrated))
(define-inline (sfun/Ginfo-integrated-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o integrated) v))
(define-inline (sfun/Ginfo-owner::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o owner))
(define-inline (sfun/Ginfo-owner-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o owner) v))
(define-inline (sfun/Ginfo-imark::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o imark))
(define-inline (sfun/Ginfo-imark-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o imark) v))
(define-inline (sfun/Ginfo-integrator::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o integrator))
(define-inline (sfun/Ginfo-integrator-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o integrator) v))
(define-inline (sfun/Ginfo-efunctions::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o efunctions))
(define-inline (sfun/Ginfo-efunctions-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o efunctions) v))
(define-inline (sfun/Ginfo-cto*::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o cto*))
(define-inline (sfun/Ginfo-cto*-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o cto*) v))
(define-inline (sfun/Ginfo-cto::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o cto))
(define-inline (sfun/Ginfo-cto-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o cto) v))
(define-inline (sfun/Ginfo-cfrom*::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o cfrom*))
(define-inline (sfun/Ginfo-cfrom*-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o cfrom*) v))
(define-inline (sfun/Ginfo-cfrom::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o cfrom))
(define-inline (sfun/Ginfo-cfrom-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o cfrom) v))
(define-inline (sfun/Ginfo-G?::bool o::sfun/Ginfo) (-> |#!bigloo_wallow| o G?))
(define-inline (sfun/Ginfo-G?-set! o::sfun/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o G?) v))
(define-inline (sfun/Ginfo-stackable::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o stackable))
(define-inline (sfun/Ginfo-stackable-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o stackable) v))
(define-inline (sfun/Ginfo-strength::symbol o::sfun/Ginfo) (-> |#!bigloo_wallow| o strength))
(define-inline (sfun/Ginfo-strength-set! o::sfun/Ginfo v::symbol) (set! (-> |#!bigloo_wallow| o strength) v))
(define-inline (sfun/Ginfo-the-closure-global::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o the-closure-global))
(define-inline (sfun/Ginfo-the-closure-global-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o the-closure-global) v))
(define-inline (sfun/Ginfo-keys::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o keys))
(define-inline (sfun/Ginfo-keys-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o keys) v))
(define-inline (sfun/Ginfo-optionals::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o optionals))
(define-inline (sfun/Ginfo-optionals-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o optionals) v))
(define-inline (sfun/Ginfo-loc::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o loc))
(define-inline (sfun/Ginfo-loc-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o loc) v))
(define-inline (sfun/Ginfo-dsssl-keywords::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o dsssl-keywords))
(define-inline (sfun/Ginfo-dsssl-keywords-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o dsssl-keywords) v))
(define-inline (sfun/Ginfo-class::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o class))
(define-inline (sfun/Ginfo-class-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o class) v))
(define-inline (sfun/Ginfo-body::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o body))
(define-inline (sfun/Ginfo-body-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o body) v))
(define-inline (sfun/Ginfo-args-name::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o args-name))
(define-inline (sfun/Ginfo-args-name-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o args-name) v))
(define-inline (sfun/Ginfo-args::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o args))
(define-inline (sfun/Ginfo-args-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o args) v))
(define-inline (sfun/Ginfo-property::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o property))
(define-inline (sfun/Ginfo-property-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o property) v))
(define-inline (sfun/Ginfo-args-retescape::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o args-retescape))
(define-inline (sfun/Ginfo-args-retescape-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o args-retescape) v))
(define-inline (sfun/Ginfo-args-noescape::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o args-noescape))
(define-inline (sfun/Ginfo-args-noescape-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o args-noescape) v))
(define-inline (sfun/Ginfo-failsafe::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o failsafe))
(define-inline (sfun/Ginfo-failsafe-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o failsafe) v))
(define-inline (sfun/Ginfo-effect::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o effect))
(define-inline (sfun/Ginfo-effect-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o effect) v))
(define-inline (sfun/Ginfo-the-closure::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o the-closure))
(define-inline (sfun/Ginfo-the-closure-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o the-closure) v))
(define-inline (sfun/Ginfo-top?::bool o::sfun/Ginfo) (-> |#!bigloo_wallow| o top?))
(define-inline (sfun/Ginfo-top?-set! o::sfun/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o top?) v))
(define-inline (sfun/Ginfo-stack-allocator::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o stack-allocator))
(define-inline (sfun/Ginfo-stack-allocator-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o stack-allocator) v))
(define-inline (sfun/Ginfo-predicate-of::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o predicate-of))
(define-inline (sfun/Ginfo-predicate-of-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o predicate-of) v))
(define-inline (sfun/Ginfo-side-effect::obj o::sfun/Ginfo) (-> |#!bigloo_wallow| o side-effect))
(define-inline (sfun/Ginfo-side-effect-set! o::sfun/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o side-effect) v))
(define-inline (sfun/Ginfo-arity::long o::sfun/Ginfo) (-> |#!bigloo_wallow| o arity))
(define-inline (sfun/Ginfo-arity-set! o::sfun/Ginfo v::long) (set! (-> |#!bigloo_wallow| o arity) v))

;; svar/Ginfo
(define-inline (make-svar/Ginfo::svar/Ginfo loc1270::obj kaptured?1271::bool free-mark1272::long mark1273::long celled?1274::bool stackable1275::bool) (instantiate::svar/Ginfo (loc loc1270) (kaptured? kaptured?1271) (free-mark free-mark1272) (mark mark1273) (celled? celled?1274) (stackable stackable1275)))
(define-inline (svar/Ginfo?::bool obj::obj) ((@ isa? __object) obj (@ svar/Ginfo globalize_ginfo)))
(define (svar/Ginfo-nil::svar/Ginfo) (class-nil (@ svar/Ginfo globalize_ginfo)))
(define-inline (svar/Ginfo-stackable::bool o::svar/Ginfo) (-> |#!bigloo_wallow| o stackable))
(define-inline (svar/Ginfo-stackable-set! o::svar/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o stackable) v))
(define-inline (svar/Ginfo-celled?::bool o::svar/Ginfo) (-> |#!bigloo_wallow| o celled?))
(define-inline (svar/Ginfo-celled?-set! o::svar/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o celled?) v))
(define-inline (svar/Ginfo-mark::long o::svar/Ginfo) (-> |#!bigloo_wallow| o mark))
(define-inline (svar/Ginfo-mark-set! o::svar/Ginfo v::long) (set! (-> |#!bigloo_wallow| o mark) v))
(define-inline (svar/Ginfo-free-mark::long o::svar/Ginfo) (-> |#!bigloo_wallow| o free-mark))
(define-inline (svar/Ginfo-free-mark-set! o::svar/Ginfo v::long) (set! (-> |#!bigloo_wallow| o free-mark) v))
(define-inline (svar/Ginfo-kaptured?::bool o::svar/Ginfo) (-> |#!bigloo_wallow| o kaptured?))
(define-inline (svar/Ginfo-kaptured?-set! o::svar/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o kaptured?) v))
(define-inline (svar/Ginfo-loc::obj o::svar/Ginfo) (-> |#!bigloo_wallow| o loc))
(define-inline (svar/Ginfo-loc-set! o::svar/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o loc) v))

;; sexit/Ginfo
(define-inline (make-sexit/Ginfo::sexit/Ginfo handler1263::obj detached?1264::bool G?1265::bool kaptured?1266::bool free-mark1267::long mark1268::long) (instantiate::sexit/Ginfo (handler handler1263) (detached? detached?1264) (G? G?1265) (kaptured? kaptured?1266) (free-mark free-mark1267) (mark mark1268)))
(define-inline (sexit/Ginfo?::bool obj::obj) ((@ isa? __object) obj (@ sexit/Ginfo globalize_ginfo)))
(define (sexit/Ginfo-nil::sexit/Ginfo) (class-nil (@ sexit/Ginfo globalize_ginfo)))
(define-inline (sexit/Ginfo-mark::long o::sexit/Ginfo) (-> |#!bigloo_wallow| o mark))
(define-inline (sexit/Ginfo-mark-set! o::sexit/Ginfo v::long) (set! (-> |#!bigloo_wallow| o mark) v))
(define-inline (sexit/Ginfo-free-mark::long o::sexit/Ginfo) (-> |#!bigloo_wallow| o free-mark))
(define-inline (sexit/Ginfo-free-mark-set! o::sexit/Ginfo v::long) (set! (-> |#!bigloo_wallow| o free-mark) v))
(define-inline (sexit/Ginfo-kaptured?::bool o::sexit/Ginfo) (-> |#!bigloo_wallow| o kaptured?))
(define-inline (sexit/Ginfo-kaptured?-set! o::sexit/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o kaptured?) v))
(define-inline (sexit/Ginfo-G?::bool o::sexit/Ginfo) (-> |#!bigloo_wallow| o G?))
(define-inline (sexit/Ginfo-G?-set! o::sexit/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o G?) v))
(define-inline (sexit/Ginfo-detached?::bool o::sexit/Ginfo) (-> |#!bigloo_wallow| o detached?))
(define-inline (sexit/Ginfo-detached?-set! o::sexit/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o detached?) v))
(define-inline (sexit/Ginfo-handler::obj o::sexit/Ginfo) (-> |#!bigloo_wallow| o handler))
(define-inline (sexit/Ginfo-handler-set! o::sexit/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o handler) v))

;; local/Ginfo
(define-inline (make-local/Ginfo::local/Ginfo id1247::symbol name1248::obj type1249::type value1250::value access1251::obj fast-alpha1252::obj removable1253::obj occurrence1254::long occurrencew1255::long user?1256::bool key1257::long val-noescape1258::obj volatile1259::bool escape?1260::bool globalized?1261::bool) (instantiate::local/Ginfo (id id1247) (name name1248) (type type1249) (value value1250) (access access1251) (fast-alpha fast-alpha1252) (removable removable1253) (occurrence occurrence1254) (occurrencew occurrencew1255) (user? user?1256) (key key1257) (val-noescape val-noescape1258) (volatile volatile1259) (escape? escape?1260) (globalized? globalized?1261)))
(define-inline (local/Ginfo?::bool obj::obj) ((@ isa? __object) obj (@ local/Ginfo globalize_ginfo)))
(define (local/Ginfo-nil::local/Ginfo) (class-nil (@ local/Ginfo globalize_ginfo)))
(define-inline (local/Ginfo-globalized?::bool o::local/Ginfo) (-> |#!bigloo_wallow| o globalized?))
(define-inline (local/Ginfo-globalized?-set! o::local/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o globalized?) v))
(define-inline (local/Ginfo-escape?::bool o::local/Ginfo) (-> |#!bigloo_wallow| o escape?))
(define-inline (local/Ginfo-escape?-set! o::local/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o escape?) v))
(define-inline (local/Ginfo-volatile::bool o::local/Ginfo) (-> |#!bigloo_wallow| o volatile))
(define-inline (local/Ginfo-volatile-set! o::local/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o volatile) v))
(define-inline (local/Ginfo-val-noescape::obj o::local/Ginfo) (-> |#!bigloo_wallow| o val-noescape))
(define-inline (local/Ginfo-val-noescape-set! o::local/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o val-noescape) v))
(define-inline (local/Ginfo-key::long o::local/Ginfo) (-> |#!bigloo_wallow| o key))
(define-inline (local/Ginfo-key-set! o::local/Ginfo v::long) (set! (-> |#!bigloo_wallow| o key) v))
(define-inline (local/Ginfo-user?::bool o::local/Ginfo) (-> |#!bigloo_wallow| o user?))
(define-inline (local/Ginfo-user?-set! o::local/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o user?) v))
(define-inline (local/Ginfo-occurrencew::long o::local/Ginfo) (-> |#!bigloo_wallow| o occurrencew))
(define-inline (local/Ginfo-occurrencew-set! o::local/Ginfo v::long) (set! (-> |#!bigloo_wallow| o occurrencew) v))
(define-inline (local/Ginfo-occurrence::long o::local/Ginfo) (-> |#!bigloo_wallow| o occurrence))
(define-inline (local/Ginfo-occurrence-set! o::local/Ginfo v::long) (set! (-> |#!bigloo_wallow| o occurrence) v))
(define-inline (local/Ginfo-removable::obj o::local/Ginfo) (-> |#!bigloo_wallow| o removable))
(define-inline (local/Ginfo-removable-set! o::local/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o removable) v))
(define-inline (local/Ginfo-fast-alpha::obj o::local/Ginfo) (-> |#!bigloo_wallow| o fast-alpha))
(define-inline (local/Ginfo-fast-alpha-set! o::local/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o fast-alpha) v))
(define-inline (local/Ginfo-access::obj o::local/Ginfo) (-> |#!bigloo_wallow| o access))
(define-inline (local/Ginfo-access-set! o::local/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o access) v))
(define-inline (local/Ginfo-value::value o::local/Ginfo) (-> |#!bigloo_wallow| o value))
(define-inline (local/Ginfo-value-set! o::local/Ginfo v::value) (set! (-> |#!bigloo_wallow| o value) v))
(define-inline (local/Ginfo-type::type o::local/Ginfo) (-> |#!bigloo_wallow| o type))
(define-inline (local/Ginfo-type-set! o::local/Ginfo v::type) (set! (-> |#!bigloo_wallow| o type) v))
(define-inline (local/Ginfo-name::obj o::local/Ginfo) (-> |#!bigloo_wallow| o name))
(define-inline (local/Ginfo-name-set! o::local/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o name) v))
(define-inline (local/Ginfo-id::symbol o::local/Ginfo) (-> |#!bigloo_wallow| o id))
(define-inline (local/Ginfo-id-set! o::local/Ginfo v::symbol) (set! (-> |#!bigloo_wallow| o id) v))

;; global/Ginfo
(define-inline (make-global/Ginfo::global/Ginfo id1224::symbol name1225::obj type1226::type value1227::value access1228::obj fast-alpha1229::obj removable1230::obj occurrence1231::long occurrencew1232::long user?1233::bool module1234::symbol import1235::obj evaluable?1236::bool eval?1237::bool library1238::obj pragma1239::obj src1240::obj qualified-type-name1241::bstring init1242::obj alias1243::obj escape?1244::bool global-closure1245::obj) (instantiate::global/Ginfo (id id1224) (name name1225) (type type1226) (value value1227) (access access1228) (fast-alpha fast-alpha1229) (removable removable1230) (occurrence occurrence1231) (occurrencew occurrencew1232) (user? user?1233) (module module1234) (import import1235) (evaluable? evaluable?1236) (eval? eval?1237) (library library1238) (pragma pragma1239) (src src1240) (qualified-type-name qualified-type-name1241) (init init1242) (alias alias1243) (escape? escape?1244) (global-closure global-closure1245)))
(define-inline (global/Ginfo?::bool obj::obj) ((@ isa? __object) obj (@ global/Ginfo globalize_ginfo)))
(define (global/Ginfo-nil::global/Ginfo) (class-nil (@ global/Ginfo globalize_ginfo)))
(define-inline (global/Ginfo-global-closure::obj o::global/Ginfo) (-> |#!bigloo_wallow| o global-closure))
(define-inline (global/Ginfo-global-closure-set! o::global/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o global-closure) v))
(define-inline (global/Ginfo-escape?::bool o::global/Ginfo) (-> |#!bigloo_wallow| o escape?))
(define-inline (global/Ginfo-escape?-set! o::global/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o escape?) v))
(define-inline (global/Ginfo-alias::obj o::global/Ginfo) (-> |#!bigloo_wallow| o alias))
(define-inline (global/Ginfo-alias-set! o::global/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o alias) v))
(define-inline (global/Ginfo-init::obj o::global/Ginfo) (-> |#!bigloo_wallow| o init))
(define-inline (global/Ginfo-init-set! o::global/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o init) v))
(define-inline (global/Ginfo-qualified-type-name::bstring o::global/Ginfo) (-> |#!bigloo_wallow| o qualified-type-name))
(define-inline (global/Ginfo-qualified-type-name-set! o::global/Ginfo v::bstring) (set! (-> |#!bigloo_wallow| o qualified-type-name) v))
(define-inline (global/Ginfo-src::obj o::global/Ginfo) (-> |#!bigloo_wallow| o src))
(define-inline (global/Ginfo-src-set! o::global/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o src) v))
(define-inline (global/Ginfo-pragma::obj o::global/Ginfo) (-> |#!bigloo_wallow| o pragma))
(define-inline (global/Ginfo-pragma-set! o::global/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o pragma) v))
(define-inline (global/Ginfo-library::obj o::global/Ginfo) (-> |#!bigloo_wallow| o library))
(define-inline (global/Ginfo-library-set! o::global/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o library) v))
(define-inline (global/Ginfo-eval?::bool o::global/Ginfo) (-> |#!bigloo_wallow| o eval?))
(define-inline (global/Ginfo-eval?-set! o::global/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o eval?) v))
(define-inline (global/Ginfo-evaluable?::bool o::global/Ginfo) (-> |#!bigloo_wallow| o evaluable?))
(define-inline (global/Ginfo-evaluable?-set! o::global/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o evaluable?) v))
(define-inline (global/Ginfo-import::obj o::global/Ginfo) (-> |#!bigloo_wallow| o import))
(define-inline (global/Ginfo-import-set! o::global/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o import) v))
(define-inline (global/Ginfo-module::symbol o::global/Ginfo) (-> |#!bigloo_wallow| o module))
(define-inline (global/Ginfo-module-set! o::global/Ginfo v::symbol) (set! (-> |#!bigloo_wallow| o module) v))
(define-inline (global/Ginfo-user?::bool o::global/Ginfo) (-> |#!bigloo_wallow| o user?))
(define-inline (global/Ginfo-user?-set! o::global/Ginfo v::bool) (set! (-> |#!bigloo_wallow| o user?) v))
(define-inline (global/Ginfo-occurrencew::long o::global/Ginfo) (-> |#!bigloo_wallow| o occurrencew))
(define-inline (global/Ginfo-occurrencew-set! o::global/Ginfo v::long) (set! (-> |#!bigloo_wallow| o occurrencew) v))
(define-inline (global/Ginfo-occurrence::long o::global/Ginfo) (-> |#!bigloo_wallow| o occurrence))
(define-inline (global/Ginfo-occurrence-set! o::global/Ginfo v::long) (set! (-> |#!bigloo_wallow| o occurrence) v))
(define-inline (global/Ginfo-removable::obj o::global/Ginfo) (-> |#!bigloo_wallow| o removable))
(define-inline (global/Ginfo-removable-set! o::global/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o removable) v))
(define-inline (global/Ginfo-fast-alpha::obj o::global/Ginfo) (-> |#!bigloo_wallow| o fast-alpha))
(define-inline (global/Ginfo-fast-alpha-set! o::global/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o fast-alpha) v))
(define-inline (global/Ginfo-access::obj o::global/Ginfo) (-> |#!bigloo_wallow| o access))
(define-inline (global/Ginfo-access-set! o::global/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o access) v))
(define-inline (global/Ginfo-value::value o::global/Ginfo) (-> |#!bigloo_wallow| o value))
(define-inline (global/Ginfo-value-set! o::global/Ginfo v::value) (set! (-> |#!bigloo_wallow| o value) v))
(define-inline (global/Ginfo-type::type o::global/Ginfo) (-> |#!bigloo_wallow| o type))
(define-inline (global/Ginfo-type-set! o::global/Ginfo v::type) (set! (-> |#!bigloo_wallow| o type) v))
(define-inline (global/Ginfo-name::obj o::global/Ginfo) (-> |#!bigloo_wallow| o name))
(define-inline (global/Ginfo-name-set! o::global/Ginfo v::obj) (set! (-> |#!bigloo_wallow| o name) v))
(define-inline (global/Ginfo-id::symbol o::global/Ginfo) (-> |#!bigloo_wallow| o id))
(define-inline (global/Ginfo-id-set! o::global/Ginfo v::symbol) (set! (-> |#!bigloo_wallow| o id) v))
))
