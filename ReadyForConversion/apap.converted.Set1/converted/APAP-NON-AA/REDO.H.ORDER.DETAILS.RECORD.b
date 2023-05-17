SUBROUTINE REDO.H.ORDER.DETAILS.RECORD
*-------------------------------------------------------------------------
*DIS:is the record routine will default the @ID value in the field GARNISHMENT.REF
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : JEEVA T
* Program Name  : REDO.H.ORDER.DETAILS
* ODR NUMBER    : ODR-2009-10-0531 ( FIX FOR ISSUE HD1053868 )
*----------------------------------------------------------------------
*Input param = none
*output param =none
*--------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.ORDER.DETAILS

    IF  PGM.VERSION EQ ",ITEM.REQUEST" THEN
        GOSUB MAIN.PROCESS
        T(RE.ORD.BRANCH.DES)<3> = 'NOINPUT'
    END

    IF PGM.VERSION EQ ",TRANSFER.AMONG.AREAS"  THEN
        GOSUB MAIN.PROCESS
    END

    IF PGM.VERSION EQ ",RETURN.TO.SUPPLY" THEN
        GOSUB MAIN.PROCESS
    END

    IF  PGM.VERSION EQ ",DESTRUCTION" THEN
        R.NEW(RE.ORD.ORDER.STATUS) = 'Destruida'
        GOSUB MAIN.PROCESS
    END

    IF  PGM.VERSION EQ ",CANCELLATION" THEN
        R.NEW(RE.ORD.ORDER.STATUS) = 'Cancelada'
        GOSUB MAIN.PROCESS
    END

RETURN
*---------------------
MAIN.PROCESS:
    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN
*---------------------
INIT:
    ORDER.REF = ''
RETURN
*-------------------
OPENFILE:
    FN.REDO.H.ORDER.DETAILS = 'F.REDO.H.ORDER.DETAILS'
    F.REDO.H.ORDER.DETAILS = ''
    CALL OPF(FN.REDO.H.ORDER.DETAILS,F.REDO.H.ORDER.DETAILS)
RETURN
*--------------------
PROCESS:

    Y.COMPANY = ID.COMPANY
    Y.VALUE = Y.COMPANY[7,8]:'-':ID.NEW
    ORDER.REF = Y.VALUE
    R.NEW(RE.ORD.ORDER.REFERENCE) = ORDER.REF
    R.NEW(RE.ORD.DATE) = TODAY
    R.NEW(RE.ORD.REQUEST.COMPANY) = Y.COMPANY

RETURN
*---------------------
END
