* @ValidationCode : Mjo2Nzc2NjU0ODQ6Q3AxMjUyOjE3MDQyNjEwNjY0MTM6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Jan 2024 11:21:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
SUBROUTINE REDO.E.AA.GET.BILL.OUTSTANDING.HIST
*****************************************
* This is a conversion routine
* This routine accepts Bill Id(with or without Sim Ref)
* and returns OS.TOTAL.AMOUNT from the sum of all OS.PROP.AMOUNT
*
*****************************************
*MODIFICATION HISTORY
*
* 05/01/09 - BG_100021512
* Arguments changed for SIM.READ.
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*29-03-2023          Conversion Tool                   AUTO R22 CODE CONVERSION           INCLUDE TO INSERT
*29-03-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGE
*02-01-2024          VIGNESHWARI S                    R22 MANUAL CONVERSION             OPF IS ADDED
*****************************************
*

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AA.BILL.DETAILS
*****************************************
*
BILL.ID = O.DATA['%',1,1]
SIM.REF = O.DATA['%',2,1]
R.AA.BILLS = ''
IF SIM.REF THEN
CALL SIM.READ(SIM.REF, "F.AA.BILL.DETAILS.HIST", BILL.ID, R.AA.BILLS, "", "", RET.ERR)
END ELSE
*CALL F.READ("F.AA.BILL.DETAILS.HIST", BILL.ID, R.AA.BILLS, F.AA.BILLS, RET.ERR)
FN.AA.BILL.DETAILS.HIST = "F.AA.BILL.DETAILS.HIST";* R22 AUTO CONVERSION
  F.AA.BILL.DETAILS.HIST =""
CALL OPF(FN.AA.BILL.DETAILS.HIST,F.AA.BILL.DETAILS.HIST)    ;*R22 MANUAL CONVERSION -OPF IS ADDED
CALL F.READ(FN.AA.BILL.DETAILS.HIST, BILL.ID, R.AA.BILLS, F.AA.BILLS, RET.ERR);* R22 AUTO CONVERSION
END
*
IF R.AA.BILLS THEN
O.DATA = SUM(R.AA.BILLS<AA.BD.OS.PROP.AMOUNT>)
END
*
RETURN
