SUBROUTINE REDO.APAP.NOF.USER.LIST(Y.FINAL.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.USER.LIST
*--------------------------------------------------------------------------------------------------------
*Description       : This is a NOFILE  Routine to attach Enquiry REDO.APAP.ENQ.USER.LIST
*
*Linked With       : Enquiry
*In  Parameter     : REDO.APAP.NOF.USER.LIST
*Out Parameter     : REDO.APAP.NOF.USER.LIST
*Files  Used       : USER                    As              I               Mode
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*     28.10.2010           RIYAS BASHA            PACS00038011          Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
    $INSERT I_F.DEPT.ACCT.OFFICER
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------------------------------
************
INIT:
*************
    Y.ATTEMPTS          = ''
    Y.START.TIME        = ''
    Y.END.TIME          = ''
    Y.END.DATE.PORFILE  = ''
    Y.STATUS            = ''
    Y.FLAG              = ''
RETURN
*--------------------------------------------------------------------------------------------------------
***********
OPENFILE:
**********
    FN.USER = 'F.USER'
    F.USER  = ''
    CALL OPF(FN.USER,F.USER)

    FN.DEPT.ACCT.OFFICER='F.DEPT.ACCT.OFFICER'
    F.DEPT.ACCT.OFFICER=''
    CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)
RETURN
*-------------------------------------------------------------------------------------------------------
********
PROCESS:
********

    Y.USER.ID=''
    LOCATE "TXN.ID" IN D.FIELDS<1> SETTING Y.USER.POS THEN
        Y.USER.ID   = D.RANGE.AND.VALUE<Y.USER.POS>
        SEL.CMD="SELECT ":FN.USER: " WITH @ID EQ ":Y.USER.ID
    END ELSE
        SEL.CMD="SELECT ":FN.USER
    END
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.USER.ID FROM SEL.LIST SETTING POS
    WHILE Y.USER.ID:POS
        CALL CACHE.READ(FN.USER, Y.USER.ID, REC.USER, Y.USER.ERR)
        Y.USER.NAME=REC.USER<EB.USE.USER.NAME>
        Y.DEPT=REC.USER<EB.USE.DEPARTMENT.CODE>
        CALL CACHE.READ(FN.DEPT.ACCT.OFFICER, Y.DEPT, R.DAO, Y.DAO.ERR)
        Y.DEPARTMENT=R.DAO<EB.DAO.NAME>
        Y.START.DATE=REC.USER<EB.USE.START.DATE.PROFILE>
        Y.END.DATE=REC.USER<EB.USE.END.DATE.PROFILE>

        Y.FLAG ='F'
        Y.ATTEMT.SINCE     = REC.USER<EB.USE.ATTEMPTS.SINCE>
        Y.ATTEMPTS         = REC.USER<EB.USE.ATTEMPTS>
        Y.START.TIME       = REC.USER<EB.USE.START.TIME>
        Y.END.TIME         = REC.USER<EB.USE.END.TIME>
        Y.END.DATE.PORFILE = REC.USER<EB.USE.END.DATE.PROFILE>
        GOSUB BLOQUEADOIF
        GOSUB BLOQUEADO
        GOSUB EXPIRADO
        GOSUB ACTIVO
        CHANGE '*' TO ' ' IN Y.STATUS
        Y.FIN.STATUS = Y.STATUS
        Y.BRANCHES=REC.USER<EB.USE.COMPANY.RESTR>
        Y.APPLICATION=REC.USER<EB.USE.APPLICATION>
        Y.FUNCTION=REC.USER<EB.USE.FUNCTION>
        Y.OVERIDE=REC.USER<EB.USE.OVERRIDE.CLASS>
        Y.ATTRIB=REC.USER<EB.USE.ATTRIBUTES>
        Y.CURR=REC.USER<EB.USE.CURR.NO>
        Y.DATETIME=REC.USER<EB.USE.DATE.TIME>
        Y.INPUTTER=REC.USER<EB.USE.INPUTTER>
*                             1                2           3             4              5                    6                7              8                9             10            11            12         13             14

        Y.FINAL.ARRAY<-1> = Y.USER.ID:"*":Y.USER.NAME:"*":Y.DEPARTMENT:"*":Y.START.DATE:"*":Y.END.DATE:"*":Y.FIN.STATUS:"*":Y.BRANCHES:"*":Y.APPLICATION:"*":Y.FUNCTION:"*":Y.OVERIDE:"*":Y.ATTRIB:"*":Y.CURR:"*":Y.DATETIME:"*":Y.INPUTTER

    REPEAT
RETURN

************
BLOQUEADOIF:
************
    IF Y.ATTEMT.SINCE GT Y.ATTEMPTS THEN
        Y.STATUS  = 'BLOQUEADO*IF'
        Y.FLAG  = 'T'
    END
RETURN
*************
BLOQUEADO:
*************
    IF Y.START.TIME EQ 0 AND Y.END.TIME EQ 0 THEN
        IF Y.FLAG EQ 'T' THEN
            Y.STATUS : = @VM:'BLOQUEADO'
        END ELSE
            Y.STATUS  = 'BLOQUEADO'
            Y.FLAG  = 'T'
        END
    END
RETURN
************
EXPIRADO:
************
    IF Y.END.DATE.PORFILE LE TODAY THEN
        IF Y.FLAG EQ 'T' THEN
            Y.STATUS : = @VM:'EXPIRADO'
        END ELSE
            Y.STATUS ='EXPIRADO'
            Y.FLAG = 'T'
        END
    END
RETURN
************
ACTIVO:
*************
    IF Y.FLAG NE 'T' THEN
        Y.STATUS = 'ACTIVO'
    END
RETURN

*-------------------------------------------------------------------------------------------------------
END
