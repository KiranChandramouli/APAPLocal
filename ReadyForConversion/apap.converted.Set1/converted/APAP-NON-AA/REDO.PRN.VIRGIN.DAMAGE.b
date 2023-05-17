SUBROUTINE REDO.PRN.VIRGIN.DAMAGE(Y.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : TAM.E.NOF.LOAN.EXP.DATE
*--------------------------------------------------------------------------------------------------------
*Description  : This is nofile enquiry routine is used to retrieve the Expiration loan List from multiple files
*Linked With  : Enquiry REDO.E.NOF.LOAN.EXP.DATE
*In Parameter : N/A
*Out Parameter: LN.ARRAY
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
*  15th SEPT 2010   JEEVA T              ODR-2010-03-0152        Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.BRANCH.REQ.STOCK


    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.REDO.BRANCH.REQ.STOCK ='F.REDO.BRANCH.REQ.STOCK'
    F.REDO.BRANCH.REQ.STOCK = ''
    CALL OPF(FN.REDO.BRANCH.REQ.STOCK,F.REDO.BRANCH.REQ.STOCK)

    LOCATE "DATE" IN D.FIELDS<1> SETTING Y.AGENCY.POS  THEN
        Y.DATE= D.RANGE.AND.VALUE<Y.AGENCY.POS>
        Y.FROM.DATE = FIELD(Y.DATE,@SM,1)
        Y.TO.DATE = FIELD(Y.DATE,@SM,2)
    END
    Y.ARRAY = ''
    Y.REQUEST.ID= ''
    Y.INTIAL.STK = ''
    Y.QTY.REQUEST = ''
    Y.LOST = ''
    Y.DAMAGE = ''
    Y.RETURN = ''
    Y.AGENCY = ''
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB SELECT.CMD
    CALL EB.READLIST(SEL.CMD.VIR,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS1
    WHILE Y.ID : POS1
        CALL F.READ(FN.REDO.BRANCH.REQ.STOCK,Y.ID,R.REDO.BRANCH.REQ.STOCK,F.REDO.BRANCH.REQ.STOCK,Y.ERR.READ)
        Y.REQUEST.DATE.LIST = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.REQUEST.DATE>
        GOSUB CALC.VALUE
    REPEAT
RETURN
*-----------------------------------------------------------------------------
SELECT.CMD:
*-----------------------------------------------------------------------------
    SEL.CMD.VIR = "SELECT ":FN.REDO.BRANCH.REQ.STOCK:" WITH (REQUEST.DATE GE ":Y.FROM.DATE:" AND WITH REQUEST.DATE LE ":Y.TO.DATE:" )"
RETURN
*-----------------------------------------------------------------------------
CALC.VALUE:
*-----------------------------------------------------------------------------
    Y.COUNT = DCOUNT(Y.REQUEST.DATE.LIST,@VM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.COUNT
        Y.REQ.DATE = Y.REQUEST.DATE.LIST<1,Y.CNT>
        IF Y.REQ.DATE GE Y.FROM.DATE AND Y.REQ.DATE LE Y.TO.DATE THEN
            GOSUB FINAL.ARRAY
        END
        Y.CNT += 1
    REPEAT
RETURN
*----------------------------------------------------------------------
FINAL.ARRAY:
*----------------------------------------------------------------------
    Y.REQUEST.ID  = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.REQUEST.ID,Y.CNT>
    Y.INTIAL.STK  = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.STK,Y.CNT>
    Y.QTY.REQUEST = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.QTY.REQUEST,Y.CNT>
    Y.LOST        = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.LOST,Y.CNT>
    Y.DAMAGE      = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.DAMAGE,Y.CNT>
    Y.RETURN      = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.RETURN,Y.CNT>
    Y.AGENCY      = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.AGENCY,Y.CNT>

    IF Y.LOST EQ '' AND Y.DAMAGE EQ '' AND Y.RETURN EQ '' THEN
        Y.FLAG = '1'
    END
    IF Y.FLAG EQ '' THEN
        IF Y.ARRAY EQ '' THEN
*                        1            2          3               4                5          6            7           8
            Y.ARRAY =  Y.REQUEST.ID:"*":Y.ID:"*":Y.INTIAL.STK:"*":Y.QTY.REQUEST:"*":Y.LOST:"*":Y.DAMAGE:"*":Y.RETURN:"*":Y.AGENCY
        END ELSE
            Y.ARRAY<-1> = Y.REQUEST.ID:"*":Y.ID:"*":Y.INTIAL.STK:"*":Y.QTY.REQUEST:"*":Y.LOST:"*":Y.DAMAGE:"*":Y.RETURN:"*":Y.AGENCY
        END

    END
    Y.REQUEST.ID= ''
    Y.INTIAL.STK = ''
    Y.QTY.REQUEST = ''
    Y.LOST = ''
    Y.DAMAGE = ''
    Y.RETURN = ''
    Y.AGENCY = ''
    Y.FLAG = ''
RETURN
END
