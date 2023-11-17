* @ValidationCode : MjotNzk1MTQ0MjA2OkNwMTI1MjoxNjg0NDkxMDMyMjM4OklUU1M6LTE6LTE6OTU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 95
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.E.AA.GET.BILL.DETAILS
*****************************************
* This is a conversion routine
* This routine accepts Bill Id(with or without Sim Ref)
* and returns OR.TOTAL.AMOUNT, OS.TOTAL.AMOUNT, BILL.ST.DATE and AGE.ST.DT delimited by *
*
*****************************************
*MODIFICATION HISTORY
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.BILL.DETAILS
*****************************************
*
*** <region name= Main control>
*** <desc>main control logic in the sub-routine</desc>

    BILL.ID = O.DATA['%',1,1]
    SIM.REF = O.DATA['%',2,1]
    R.BILLS = ''

    FN.AA.ACCOUNT.DETAILS = "F.":R.ENQ<2>
    FN.AA.BILL.DETAILS = CHANGE(FN.AA.ACCOUNT.DETAILS,"AA.ACCOUNT.DETAILS","AA.BILL.DETAILS")

    TOTAL.ORIGINAL.PAYMENT.AMOUNT = ''  ;* Original property amount

    IF SIM.REF THEN
        CALL SIM.READ(SIM.REF, FN.AA.BILL.DETAILS, BILL.ID, R.BILLS, "", "", RET.ERR)
    END ELSE
        CALL F.READ(FN.AA.BILL.DETAILS, BILL.ID, R.BILLS, F.AA.BILLS, RET.ERR)
    END
*

    O.DATA = R.BILLS<AA.BD.OR.TOTAL.AMOUNT>:'*':R.BILLS<AA.BD.OS.TOTAL.AMOUNT>:'*':R.BILLS<AA.BD.BILL.ST.CHG.DT,1>:'*':R.BILLS<AA.BD.AGING.ST.CHG.DT,1>
*
RETURN
*** </region>
*----------------------------------------------------------------------------------
END
