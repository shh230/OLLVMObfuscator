; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Test that the reverse is eliminated if the output and all the inputs
; of the instruction are calls to reverse.
define <vscale x 4 x i32> @binop_reverse(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: @binop_reverse(
; CHECK-NEXT:    [[ADD1:%.*]] = add <vscale x 4 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret <vscale x 4 x i32> [[ADD1]]
;
  %reva = tail call <vscale x 4 x i32> @llvm.experimental.vector.reverse.nxv4i32(<vscale x 4 x i32> %a)
  %revb = tail call <vscale x 4 x i32> @llvm.experimental.vector.reverse.nxv4i32(<vscale x 4 x i32> %b)
  %add = add <vscale x 4 x i32> %reva, %revb
  %revadd = tail call <vscale x 4 x i32> @llvm.experimental.vector.reverse.nxv4i32(<vscale x 4 x i32> %add)
  ret <vscale x 4 x i32> %revadd
}

define <vscale x 4 x i32> @binop_reverse_splat_RHS(<vscale x 4 x i32> %a, i32 %b) {
; CHECK-LABEL: @binop_reverse_splat_RHS(
; CHECK-NEXT:    [[SPLAT_INSERT:%.*]] = insertelement <vscale x 4 x i32> poison, i32 [[B:%.*]], i64 0
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <vscale x 4 x i32> [[SPLAT_INSERT]], <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:    [[UDIV1:%.*]] = udiv <vscale x 4 x i32> [[A:%.*]], [[SPLAT]]
; CHECK-NEXT:    ret <vscale x 4 x i32> [[UDIV1]]
;
  %reva = tail call <vscale x 4 x i32> @llvm.experimental.vector.reverse.nxv4i32(<vscale x 4 x i32> %a)
  %splat_insert = insertelement <vscale x 4 x i32> poison, i32 %b, i32 0
  %splat = shufflevector <vscale x 4 x i32> %splat_insert, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %udiv = udiv <vscale x 4 x i32> %reva, %splat
  %revadd = tail call <vscale x 4 x i32> @llvm.experimental.vector.reverse.nxv4i32(<vscale x 4 x i32> %udiv)
  ret <vscale x 4 x i32> %revadd
}

define <vscale x 4 x i32> @binop_reverse_splat_LHS(<vscale x 4 x i32> %a, i32 %b) {
; CHECK-LABEL: @binop_reverse_splat_LHS(
; CHECK-NEXT:    [[SPLAT_INSERT:%.*]] = insertelement <vscale x 4 x i32> poison, i32 [[B:%.*]], i64 0
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <vscale x 4 x i32> [[SPLAT_INSERT]], <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:    [[UDIV1:%.*]] = udiv <vscale x 4 x i32> [[SPLAT]], [[A:%.*]]
; CHECK-NEXT:    ret <vscale x 4 x i32> [[UDIV1]]
;
  %reva = tail call <vscale x 4 x i32> @llvm.experimental.vector.reverse.nxv4i32(<vscale x 4 x i32> %a)
  %splat_insert = insertelement <vscale x 4 x i32> poison, i32 %b, i32 0
  %splat = shufflevector <vscale x 4 x i32> %splat_insert, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %udiv = udiv <vscale x 4 x i32> %splat, %reva
  %revadd = tail call <vscale x 4 x i32> @llvm.experimental.vector.reverse.nxv4i32(<vscale x 4 x i32> %udiv)
  ret <vscale x 4 x i32> %revadd
}

define <vscale x 4 x float> @unop_reverse(<vscale x 4 x float> %a) {
; CHECK-LABEL: @unop_reverse(
; CHECK-NEXT:    [[NEG1:%.*]] = fneg fast <vscale x 4 x float> [[A:%.*]]
; CHECK-NEXT:    ret <vscale x 4 x float> [[NEG1]]
;
  %reva = tail call <vscale x 4 x float> @llvm.experimental.vector.reverse.nxv4f32(<vscale x 4 x float> %a)
  %neg = fneg fast <vscale x 4 x float> %reva
  %revneg = tail call <vscale x 4 x float> @llvm.experimental.vector.reverse.nxv4f32(<vscale x 4 x float> %neg)
  ret <vscale x 4 x float> %revneg
}

declare <vscale x 4 x float> @llvm.experimental.vector.reverse.nxv4f32(<vscale x 4 x float>)
declare <vscale x 4 x i32> @llvm.experimental.vector.reverse.nxv4i32(<vscale x 4 x i32>)


