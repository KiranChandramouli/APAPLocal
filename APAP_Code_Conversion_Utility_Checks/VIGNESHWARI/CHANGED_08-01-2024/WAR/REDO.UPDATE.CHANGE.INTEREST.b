* @ValidationCode : MjotODg2NzI1ODc0OkNwMTI1MjoxNzA0NDQyMDY1NjQ5OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 13:37:45
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
SUBROUTINE REDO.UPDATE.CHANGE.INTEREST
    
*-----------------------------------------------------------------------------
* CODED BY      : JEEVA T
* ODR           : ODR-201003178.RRD152
*-----------------------------------------------------------------------------
*  Description of the routine
*-----------------------------------------------------------------------------
*REDO.UPDATE.CHANGE.INTEREST is used to populate the CONCAT file REDO.CHANGE.INT.ARR file with the
*Arrangement id. This is triggered as a post routine when LENDING-CHANGE-INTEREST
*is triggered
** 29-03-2023 R22 Auto Conversion - no changes
** 29-03-2023 Skanda R22 Manual Conversion - No changes
* Date              Who           Reference                       DESCRIPTION
*05-01-2024      VIGNESHWARI S   R23 Manual Code Conversion       AA.FRAMEWORK IS MODIFIED  
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
*$INSERT I_AA.LOCAL.COMMON
$INSERT I_F.AA.INTEREST
   $USING AA.Framework
   $USING EB.TransactionControl

GOSUB GET.LOC.VALUES
GOSUB OPENFILES
GOSUB PROCESS


RETURN
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------

FN.REDO.CHANGE.INT.ARRANGEMENT='F.REDO.CHANGE.INT.ARRANGEMENT'
F.REDO.CHANGE.INT.ARRANGEMENT=''
CALL OPF(FN.REDO.CHANGE.INT.ARRANGEMENT,F.REDO.CHANGE.INT.ARRANGEMENT)
R.REDO.CHANGE.INT.ARRANGEMENT=''
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

*Y.AA.ID=c_aalocArrId
Y.AA.ID=AA.Framework.getC_aalocarrid();*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK IS MODIFIED
GOSUB GET.ARR.COND
Y.ID.NEW=Y.AA.ID:"-":Y.NEXT.REVIEW.DATE
CALL F.WRITE(FN.REDO.CHANGE.INT.ARRANGEMENT,Y.ID.NEW,R.REDO.CHANGE.INT.ARRANGEMENT)
*CALL JOURNAL.UPDATE(Y.ID.NEW)
EB.TransactionControl.JournalUpdate(Y.ID.NEW);* R22 AUTO CONVERSION
RETURN

*-----------------------------------------------------------------------------
ARR.CONDITIONS:
*-----------------------------------------------------------------------------
ArrangementID = Y.AA.ID ; idProperty = ''; effectiveDate = ''; returnIds = ''; R.CONDITION =''; returnConditions =''; returnError = ''
*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);* R22 AUTO CONVERSION
RETURN
*-----------------------------------------------------------------------------
GET.ARR.COND:
*-----------------------------------------------------------------------------
Y.NEXT.REVIEW.DATE = R.NEW(AA.INT.LOCAL.REF)<1,Y.NEXT.REV.DATE.POS>
RETURN
*-----------------------------------------------------------------------------
GET.LOC.VALUES:
*-----------------------------------------------------------------------------

LOC.REF.APPL="AA.PRD.DES.INTEREST"
LOC.REF.FIELDS="L.AA.NXT.REV.DT"
LOC.REF.POS=""
CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
Y.NEXT.REV.DATE.POS  =  LOC.REF.POS<1,1>

RETURN
*-----------------------------------------------------------------------------
END
