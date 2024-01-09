* @ValidationCode : Mjo3MjgxMDk5MjY6Q3AxMjUyOjE3MDQzNjgwMzgxNzY6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Jan 2024 17:03:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.MOVE.PART.PAY.HIST(RECORD.ID)
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH
* PROGRAM NAME : REDO.B.MOVE.PART.PAY.HIST
*----------------------------------------------------------


* DESCRIPTION : This routine is a multi threaded routine to process the bill numbers and move them to History state
*
*
*------------------------------------------------------------

*    LINKED WITH : REDO.B.MOVE.PART.PAY.HIST.LOAD,REDO.B.MOVE.PART.PAY.HIST.SELECT
*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*31.05.2010      GANESH            ODR-2010-08-0017        INITIAL CREATION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*----------------------------------------------------------------------


*-------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.B.MOVE.PART.PAY.HIST.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.REDO.H.PART.PAY.FT
    $INSERT I_F.REDO.H.PART.PAY.TT
    V.WORK.FILE.LIST = CONTROL.LIST<1,1>
    IF V.WORK.FILE.LIST EQ 'FT.LIST' THEN
        GOSUB FT.PROCESS
    END
    IF V.WORK.FILE.LIST EQ 'TT.LIST' THEN
        GOSUB TT.PROCESS
    END
RETURN

***********
FT.PROCESS:

    PAY.FT.ID = RECORD.ID
*CALL F.READ(FN.REDO.H.PART.PAY.FT,PAY.FT.ID,R.REDO.H.PART.PAY.FT,F.REDO.H.PART.PAY.FT,PAY.FT.ERR)
    CALL F.READU(FN.REDO.H.PART.PAY.FT,PAY.FT.ID,R.REDO.H.PART.PAY.FT,F.REDO.H.PART.PAY.FT,PAY.FT.ERR,'');* R22 AUTO CONVERSION
    VAR.BILL.NUM = R.REDO.H.PART.PAY.FT<PART.PAY.BILL.NUMBER>
    CALL F.READ(FN.AA.BILL.DETAILS,VAR.BILL.NUM,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,AA.BILL.ERR)
    VAR.BILL.STATUS = R.AA.BILL.DETAILS<AA.BD.SETTLE.STATUS,1>
    IF VAR.BILL.STATUS EQ 'REPAID' THEN
        CALL F.WRITE(FN.REDO.H.PART.PAY.FT.HIS,PAY.FT.ID,R.REDO.H.PART.PAY.FT)
        CALL F.DELETE(FN.REDO.H.PART.PAY.FT,PAY.FT.ID)
    END
RETURN

************
TT.PROCESS:

    PAY.TT.ID = RECORD.ID
*CALL F.READ(FN.REDO.H.PART.PAY.TT,PAY.TT.ID,R.REDO.H.PART.PAY.TT,F.REDO.H.PART.PAY.TT,PAY.TT.ERR)
    CALL F.READU(FN.REDO.H.PART.PAY.TT,PAY.TT.ID,R.REDO.H.PART.PAY.TT,F.REDO.H.PART.PAY.TT,PAY.TT.ERR,'');* R22 AUTO CONVERSION
    VAR.BILL.NUM = R.REDO.H.PART.PAY.TT<PART.PAY.BILL.NUMBER>
    CALL F.READ(FN.AA.BILL.DETAILS,VAR.BILL.NUM,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,AA.BILL.ERR)
    VAR.BILL.STATUS = R.AA.BILL.DETAILS<AA.BD.SETTLE.STATUS,1>
    IF VAR.BILL.STATUS EQ 'REPAID' THEN
        CALL F.WRITE(FN.REDO.H.PART.PAY.TT.HIS,PAY.TT.ID,R.REDO.H.PART.PAY.TT)
        CALL F.DELETE(FN.REDO.H.PART.PAY.TT,PAY.TT.ID)
    END
RETURN
END
