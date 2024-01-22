* @ValidationCode : Mjo2NTYwMTAwODk6Q3AxMjUyOjE3MDQxOTk5MDI4Nzg6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Jan 2024 18:21:42
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
SUBROUTINE REDO.CORRECTION.AA1512050715
*--------------------------------------------------------------
*Description: This TAM correction routine is to move the AA.ARR.TERM.AMOUNT record
*             from INAU to Live for the arrangement - REDO.CORRECTION.AA1512050715. Since it is been in INAU.
*
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 29-MAR-2023      Conversion Tool       R22 Auto Conversion - No changes
* 29-MAR-2023      Harsha                R22 Manual Conversion - No changes
* 02-01-2024      VIGNESHWARI               R22 AUTO Conversion - CALL RTN MODIFIED
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
   $USING EB.TransactionControl
   

EXECUTE  "COMO ON REDO.CORRECTION.AA1512050715"

CALL OCOMO("Process initiated")
FN.AA.ARR.TERM.AMOUNT = "F.AA.ARR.TERM.AMOUNT"
F.AA.ARR.TERM.AMOUNT  = ""
CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

FN.AA.ARR.TERM.AMOUNT$NAU = "F.AA.ARR.TERM.AMOUNT$NAU"
F.AA.ARR.TERM.AMOUNT$NAU  = ""
CALL OPF(FN.AA.ARR.TERM.AMOUNT$NAU,F.AA.ARR.TERM.AMOUNT$NAU)

Y.LIVE.TERM.ID = "AA1512050715-COMMITMENT-20150507.3"
*CALL F.READ(FN.AA.ARR.TERM.AMOUNT,Y.LIVE.TERM.ID,R.AA.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT,TERM.ERR)
CALL F.READU(FN.AA.ARR.TERM.AMOUNT,Y.LIVE.TERM.ID,R.AA.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT,TERM.ERR,'');* R22 AUTO CONVERSION
IF R.AA.TERM.AMOUNT ELSE
CALL OCOMO("Live term amount record missing")
RETURN
END

R.AA.TERM.AMOUNT<2> = "DRAW"

Y.DELETE.ID = "AA1512050715-COMMITMENT-20150507.4"

CALL F.WRITE(FN.AA.ARR.TERM.AMOUNT,Y.DELETE.ID,R.AA.TERM.AMOUNT)
CALL F.DELETE(FN.AA.ARR.TERM.AMOUNT$NAU,Y.DELETE.ID)
CALL OCOMO("Process completed...")
EXECUTE  "COMO OFF REDO.CORRECTION.AA1512050715"
*CALL JOURNAL.UPDATE("")
EB.TransactionControl.JournalUpdate("");* R22 AUTO CONVERSION
RETURN
END
