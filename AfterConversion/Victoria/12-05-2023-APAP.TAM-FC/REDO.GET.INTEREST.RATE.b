$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.INTEREST.RATE(ARR.ID,INT.RATE)
*---------------------------------------------------
* Description: Routine to get the interest rate of an arrangement.
*---------------------------------------------------
* Input Arg: Arrangement ID.
* Output Arg: Interest Rate.
*---------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
* 09 Dec 2011    H Ganesh               PACS00149083 - B.16    Initial Draft.
** 10-04-2023 R22 Auto Conversion no changes
** 10-04-2023 Skanda R22 Manual Conversion - Call routine Added
*---------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.INTEREST

    GOSUB PROCESS
RETURN
*---------------------------------------------------
PROCESS:
*---------------------------------------------------
    GOSUB GET.PROPERTY

    Y.ARRG.ID = ARR.ID
    PROPERTY.CLASS = 'INTEREST'
    PROPERTY = Y.PRIN.PROP
    EFF.DATE = ''
    ERR.MSG = ''
    R.INT.ARR.COND = ''
*CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.INT.ARR.COND,ERR.MSG)
*R22 MANUAL CONVERSION
    CALL APAP.TAM.redoCrrGetConditions(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.INT.ARR.COND,ERR.MSG)
    INT.RATE = R.INT.ARR.COND<AA.INT.EFFECTIVE.RATE,1>

RETURN
*---------------------------------------------------
GET.PROPERTY:
*---------------------------------------------------
* To get the interest property.

    PROP.NAME='PRINCIPAL'       ;* Interest Property to obtain
*CALL REDO.GET.INTEREST.PROPERTY(ARR.ID,PROP.NAME,OUT.PROP,ERR)
*R22 MANUAL CONVERSION
    CALL APAP.TAM.redoGetInterestProperty(ARR.ID,PROP.NAME,OUT.PROP,ERR)
    Y.PRIN.PROP=OUT.PROP        ;* This variable hold the value of principal interest property

RETURN
END
