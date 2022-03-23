; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc < %s -mtriple arm64-apple-darwin -global-isel -stop-after=irtranslator -verify-machineinstrs | FileCheck %s

; Check that we don't try to tail-call with a non-forwarded sret parameter.
declare void @test_explicit_sret(i64* sret(i64))

; Forwarded explicit sret pointer => we can tail call.
define void @can_tail_call_forwarded_explicit_sret_ptr(i64* sret(i64) %arg) {
  ; CHECK-LABEL: name: can_tail_call_forwarded_explicit_sret_ptr
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x8
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x8
  ; CHECK:   $x8 = COPY [[COPY]](p0)
  ; CHECK:   TCRETURNdi @test_explicit_sret, 0, csr_darwin_aarch64_aapcs, implicit $sp, implicit $x8
  tail call void @test_explicit_sret(i64* %arg)
  ret void
}

; Not marked as tail, so don't tail call.
define void @test_call_explicit_sret(i64* sret(i64) %arg) {
  ; CHECK-LABEL: name: test_call_explicit_sret
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x8
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x8
  ; CHECK:   ADJCALLSTACKDOWN 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   $x8 = COPY [[COPY]](p0)
  ; CHECK:   BL @test_explicit_sret, csr_darwin_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $x8
  ; CHECK:   ADJCALLSTACKUP 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   RET_ReallyLR
  call void @test_explicit_sret(i64* %arg)
  ret void
}

define void @dont_tail_call_explicit_sret_alloca_unused() {
  ; CHECK-LABEL: name: dont_tail_call_explicit_sret_alloca_unused
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   [[FRAME_INDEX:%[0-9]+]]:_(p0) = G_FRAME_INDEX %stack.0.l
  ; CHECK:   ADJCALLSTACKDOWN 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   $x8 = COPY [[FRAME_INDEX]](p0)
  ; CHECK:   BL @test_explicit_sret, csr_darwin_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $x8
  ; CHECK:   ADJCALLSTACKUP 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   RET_ReallyLR
  %l = alloca i64, align 8
  tail call void @test_explicit_sret(i64* %l)
  ret void
}

define void @dont_tail_call_explicit_sret_alloca_dummyusers(i64* %ptr) {
  ; CHECK-LABEL: name: dont_tail_call_explicit_sret_alloca_dummyusers
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x0
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK:   [[FRAME_INDEX:%[0-9]+]]:_(p0) = G_FRAME_INDEX %stack.0.l
  ; CHECK:   [[LOAD:%[0-9]+]]:_(s64) = G_LOAD [[COPY]](p0) :: (load (s64) from %ir.ptr)
  ; CHECK:   G_STORE [[LOAD]](s64), [[FRAME_INDEX]](p0) :: (store (s64) into %ir.l)
  ; CHECK:   ADJCALLSTACKDOWN 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   $x8 = COPY [[FRAME_INDEX]](p0)
  ; CHECK:   BL @test_explicit_sret, csr_darwin_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $x8
  ; CHECK:   ADJCALLSTACKUP 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   RET_ReallyLR
  %l = alloca i64, align 8
  %r = load i64, i64* %ptr, align 8
  store i64 %r, i64* %l, align 8
  tail call void @test_explicit_sret(i64* %l)
  ret void
}

define void @dont_tail_call_tailcall_explicit_sret_gep(i64* %ptr) {
  ; CHECK-LABEL: name: dont_tail_call_tailcall_explicit_sret_gep
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x0
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 8
  ; CHECK:   [[PTR_ADD:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C]](s64)
  ; CHECK:   ADJCALLSTACKDOWN 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   $x8 = COPY [[PTR_ADD]](p0)
  ; CHECK:   BL @test_explicit_sret, csr_darwin_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $x8
  ; CHECK:   ADJCALLSTACKUP 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   RET_ReallyLR
  %ptr2 = getelementptr i64, i64* %ptr, i32 1
  tail call void @test_explicit_sret(i64* %ptr2)
  ret void
}

define i64 @dont_tail_call_sret_alloca_returned() {
  ; CHECK-LABEL: name: dont_tail_call_sret_alloca_returned
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   [[FRAME_INDEX:%[0-9]+]]:_(p0) = G_FRAME_INDEX %stack.0.l
  ; CHECK:   ADJCALLSTACKDOWN 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   $x8 = COPY [[FRAME_INDEX]](p0)
  ; CHECK:   BL @test_explicit_sret, csr_darwin_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $x8
  ; CHECK:   ADJCALLSTACKUP 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   [[LOAD:%[0-9]+]]:_(s64) = G_LOAD [[FRAME_INDEX]](p0) :: (dereferenceable load (s64) from %ir.l)
  ; CHECK:   $x0 = COPY [[LOAD]](s64)
  ; CHECK:   RET_ReallyLR implicit $x0
  %l = alloca i64, align 8
  tail call void @test_explicit_sret(i64* %l)
  %r = load i64, i64* %l, align 8
  ret i64 %r
}