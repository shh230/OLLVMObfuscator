; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM
; PR5596

; IPSCCP should propagate the 0 argument, eliminate the switch, and propagate
; the result.

; FIXME: Remove obsolete calls/instructions

define i32 @main() noreturn nounwind {
; CHECK: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@main
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i32 123
;
entry:
  %call2 = tail call i32 @wwrite(i64 0) nounwind
  ret i32 %call2
}

define internal i32 @wwrite(i64 %i) nounwind readnone {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@wwrite
; IS__CGSCC____-SAME: () #[[ATTR1:[0-9]+]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    switch i64 0, label [[SW_DEFAULT:%.*]] [
; IS__CGSCC____-NEXT:    i64 3, label [[RETURN:%.*]]
; IS__CGSCC____-NEXT:    i64 10, label [[RETURN]]
; IS__CGSCC____-NEXT:    ]
; IS__CGSCC____:       sw.default:
; IS__CGSCC____-NEXT:    ret i32 undef
; IS__CGSCC____:       return:
; IS__CGSCC____-NEXT:    unreachable
;
entry:
  switch i64 %i, label %sw.default [
  i64 3, label %return
  i64 10, label %return
  ]

sw.default:
  ret i32 123

return:
  ret i32 0
}
;.
; IS__TUNIT____: attributes #[[ATTR0]] = { nofree norecurse noreturn nosync nounwind readnone willreturn }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { nofree norecurse noreturn nosync nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR1]] = { nofree norecurse nosync nounwind readnone willreturn }
;.
