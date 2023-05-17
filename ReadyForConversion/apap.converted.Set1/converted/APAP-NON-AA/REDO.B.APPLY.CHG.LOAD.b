SUBROUTINE REDO.B.APPLY.CHG.LOAD
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This load routine initialises and opens necessary files
*  and gets the position of the local reference fields
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who             Reference            Description
* 05-AUG-2010     S.R.SWAMINATHAN   ODR-2010-03-0400      Initial Creation
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.APPLY.CHG.COMMON
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_BATCH.FILES
    $INSERT I_GTS.COMMON
    $INSERT I_F.DATES
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.APAP.H.PARAMETER

    GOSUB INIT
    GOSUB GET.LR.FLD.POS
    GOSUB OPEN.FILE

RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
*-------------------------------------------------

    FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER = ''

    FN.CARD.TYPE = 'F.CARD.TYPE'
    F.CARD.TYPE = ''

    FN.DATES = 'F.DATES'
    F.DATES = ''

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY = ''

    FN.CATEG.ENTRY = 'F.CATEG.ENTRY'
    F.CATEG.ENTRY = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''

    FN.REDO.APAP.H.PARAMETER = 'F.REDO.APAP.H.PARAMETER'
    F.REDO.APAP.H.PARAMETER = ''

    FN.LATAM.CARD.CHARGE = 'F.LATAM.CARD.CHARGES'
    F.LATAM.CARD.CHARGE = ''

RETURN

*--------------
GET.LR.FLD.POS:
*--------------
*-------------------------------------------------------------
* This section gets the position of the local reference fields
*-------------------------------------------------------------

    Y.LRF.APPL = "CARD.TYPE":@FM:"ACCOUNT"
    Y.LRF.FIELDS = 'L.CT.CCY.CHARGE':@VM:'L.CT.CHARGE':@VM:'L.CT.CHARGE.FQ':@FM:'L.AC.STATUS1'
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(Y.LRF.APPL,Y.LRF.FIELDS,FIELD.POS)
    Y.CT.CCY.CHARGE.POS = FIELD.POS<1,1>
    Y.CT.CHARGE.POS = FIELD.POS<1,2>
    Y.CT.CHARGE.FQ.POS = FIELD.POS<1,3>
    Y.ACCT.STATUS1.POS=FIELD.POS<2,1>
    Y.APAP.PARAM.ID = "SYSTEM"
    ENTRY.REC = ''
    R.CATEG.ENTRIES = ''
    R.STMT.ENTRIES = ''

    CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,Y.APAP.PARAM.ID,R.REDO.APAP.H.PARAMETER,Y.PARAM.ERR)
    IF R.REDO.APAP.H.PARAMETER THEN
        Y.DR.CODE = R.REDO.APAP.H.PARAMETER<PARAM.DEBT.CARD.TRANS.DR>
        Y.CR.CODE = R.REDO.APAP.H.PARAMETER<PARAM.DEBT.CARD.TRANS.CR>
        Y.PL.CATEG = R.REDO.APAP.H.PARAMETER<PARAM.DEBT.CARD.PL.CATEG>
    END


RETURN

*---------
OPEN.FILE:
*---------
*---------------------------------------
* This section opens the necessary files
*---------------------------------------

    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)
    CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
    CALL OPF(FN.CATEG.ENTRY,F.CATEG.ENTRY)
    CALL OPF(FN.DATES,F.DATES)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.REDO.APAP.H.PARAMETER,F.REDO.APAP.H.PARAMETER)
    CALL OPF(FN.LATAM.CARD.CHARGE,F.LATAM.CARD.CHARGE)

RETURN

END
