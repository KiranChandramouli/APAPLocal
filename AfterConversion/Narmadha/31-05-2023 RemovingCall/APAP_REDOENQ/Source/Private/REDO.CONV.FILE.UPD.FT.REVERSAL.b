$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.FILE.UPD.FT.REVERSAL
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
*-------------------------------------------------------

*Comments
*-------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------
    FN.ACH.FT.REVE.TXN = 'F.ACH.FT.REVE.TXN'
    F.ACH.FT.REVE.TXN  = ''
    CALL OPF(FN.ACH.FT.REVE.TXN,F.ACH.FT.REVE.TXN)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.ACH.FT.REVE.TXN,O.DATA,R.ACH.FT.REVE.TXN,F.ACH.FT.REVE.TXN,ACH.FT.REVE.TXN.ERR)
    IF R.ACH.FT.REVE.TXN THEN
        O.DATA = R.ACH.FT.REVE.TXN
    END

RETURN
*---------------------------------------------------------------
END
