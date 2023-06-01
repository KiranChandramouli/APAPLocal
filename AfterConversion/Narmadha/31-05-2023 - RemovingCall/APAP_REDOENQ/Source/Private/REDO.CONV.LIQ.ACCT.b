$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.LIQ.ACCT
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : JEEVA T
* Program Name : REDO.E.PRD.SELECT
*----------------------------------------------------------

* Description   :
* Linked with   :
* In Parameter  : None
* Out Parameter : None
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10.10.2010   JEEVA T      ODR-2010-08-0031   INITIAL CREATION
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CLOSE.ACCT
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_System

    GOSUB OPEN
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
OPEN:
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.CLOSE.ACCT ='F.REDO.CLOSE.ACCT'
    F.REDO.CLOSE.ACCT = ''
    CALL OPF(FN.REDO.CLOSE.ACCT,F.REDO.CLOSE.ACCT)


RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.LIQ.ACCOUNT = ''
    ID.POS = ''
    NOF = '' ; SEL.CMD.LIST = ''
    SEL.CMD ="SELECT  ":FN.REDO.CLOSE.ACCT: " WITH LIQ.ACCOUNT EQ ":O.DATA
    CALL EB.READLIST(SEL.CMD,SEL.CMD.LIST,'',NOF,Y.ERR)
    IF SEL.CMD.LIST THEN
        O.DATA = SEL.CMD.LIST
    END
RETURN
*-----------------------------------------------------------------------------
END
