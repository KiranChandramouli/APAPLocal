SUBROUTINE REDO.B.DEPT.CODE(ENQ.DATA)
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
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
    $INSERT I_F.REDO.CLOSE.ACCT
    $INSERT I_EB.EXTERNAL.COMMON


    GOSUB OPEN
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
OPEN:

    LOC.REF.APPLICATION="USER"
    LOC.REF.FIELDS='L.US.IDC.BR':@VM:'L.US.IDC.CODE'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.BR.VAL =LOC.REF.POS<1,1>
    POS.DETP.VAL = LOC.REF.POS<1,2>
    Y.CODE.DEPT = ''
    Y.BRANCH.LIST = R.USER<EB.USE.LOCAL.REF,POS.BR.VAL>
    Y.DEPT.LIST = R.USER<EB.USE.LOCAL.REF,POS.DETP.VAL>
    CHANGE @SM TO @FM IN Y.BRANCH.LIST
    CHANGE @VM TO @FM IN Y.BRANCH.LIST
    CHANGE @VM TO @FM IN Y.DEPT.LIST
    CHANGE @SM TO @FM IN Y.DEPT.LIST

    Y.CNT = 1
    Y.COUNT = DCOUNT(Y.BRANCH.LIST,@FM)
    LOOP
    WHILE Y.CNT LE Y.COUNT
        LOCATE  ID.COMPANY IN Y.BRANCH.LIST<Y.CNT> SETTING POS THEN
            Y.CODE<-1> = Y.DEPT.LIST<Y.CNT>
        END
        Y.CNT += 1
    REPEAT
    CHANGE @FM TO ' ' IN Y.CODE
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF Y.CODE THEN
        ENQ.DATA<2,-1> ='BRANCH.CODE'
        ENQ.DATA<3,-1> ='EQ'
        ENQ.DATA<4,-1> = Y.CODE
    END ELSE
        ENQ.DATA<2,-1> ='BRANCH.CODE'
        ENQ.DATA<3,-1> ='EQ'
        ENQ.DATA<4,-1> = ''
    END
RETURN
*-----------------------------------------------------------------------------
END
