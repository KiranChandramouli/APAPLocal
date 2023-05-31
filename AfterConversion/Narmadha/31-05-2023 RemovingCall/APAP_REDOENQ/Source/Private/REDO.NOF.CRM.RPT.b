$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.CRM.RPT(CRM.ARR)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is Nofile routine to fetch the values for CRM.
* This development is for ODR Reference ODR-2010-04-0425
* Input/Output:
*--------------
* IN  : N/A
* OUT : CRM.ARR
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
* Revision History:
*------------------------------------------------------------------------------------------
* Date              who              Reference            Description
* 17-SEP-2010       S.Sudharsanan  PACS00115270     Initial Creation
* 13-APRIL-2023      Harsha                R22 Auto Conversion  - VM to @VM , FM to @FM  and SM to @SM
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.REDO.U.CRM.PRODUCT.TYPE
    $INSERT I_F.REDO.U.CRM.CLAIM.TYPE
    $INSERT I_F.REDO.SLA.PARAM
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.REDO.ISSUE.REQUESTS
    $INSERT I_F.REDO.ISSUE.COMPLAINTS

    GOSUB INIT
    GOSUB FORM.SEL.STMT
RETURN
******
INIT:
******
    CUSTOMER.NO              = '' ;  VAR.RE.INV.CATEG = ''

    FN.CUSTOMER              = 'F.CUSTOMER'             ; F.CUSTOMER               = ''
    FN.ACCOUNT               = 'F.ACCOUNT'              ; F.ACCOUNT                = ''
    FN.DEPT.ACCT.OFFICER     = 'F.DEPT.ACCT.OFFICER'    ; F.DEPT.ACCT.OFFICER      = ''
    FN.REDO.ISSUE.CLAIMS     = 'F.REDO.ISSUE.CLAIMS'    ; F.REDO.ISSUE.CLAIMS      = ''
    FN.REDO.ISSUE.REQUESTS   = 'F.REDO.ISSUE.REQUESTS'  ; F.REDO.ISSUE.REQUESTS    = ''
    FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'; F.REDO.ISSUE.COMPLAINTS  = ''
    FN.REDO.U.CRM.PRODUCT.TYPE = 'F.REDO.U.CRM.PRODUCT.TYPE' ; F.REDO.U.CRM.PRODUCT.TYPE = ''
    FN.REDO.U.CRM.CLAIM.TYPE = 'F.REDO.U.CRM.CLAIM.TYPE' ; F.REDO.U.CRM.CLAIM.TYPE = ''
    FN.REDO.SLA = 'F.REDO.SLA.PARAM' ; F.REDO.SLA = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)
    CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)
    CALL OPF(FN.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS)
    CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)
    CALL OPF(FN.REDO.U.CRM.PRODUCT.TYPE,F.REDO.U.CRM.PRODUCT.TYPE)
    CALL OPF(FN.REDO.SLA,F.REDO.SLA)
    CALL OPF(FN.REDO.U.CRM.CLAIM.TYPE,F.REDO.U.CRM.CLAIM.TYPE)
    GOSUB GET.LOCAL.FIELDS.POS
RETURN

*********************
GET.LOCAL.FIELDS.POS:
*********************
    LREF.APPL                = 'CUSTOMER'
    LREF.FIELDS              = 'L.CU.SEGMENTO':@VM:'L.CU.TIPO.CL'
    LREF.POS                 = ''
    CALL MULTI.GET.LOC.REF(LREF.APPL, LREF.FIELDS, LREF.POS)
    POS.L.CU.SEG = LREF.POS<1,1>
    POS.TIPO.CL = LREF.POS<1,2>

    Y.INPUTTER.FLAG = '' ; Y.SEGMENTO.FLAG = '' ; SEL.FIELD = '' ; VALUE.BK = '' ; OPERAND.BK = '' ; FIELDS.BK = '' ; CRM.ARR = ''
RETURN
***************
FORM.SEL.STMT:
**************
    SEL.FIELD  = ''
    SEL.CLAIMS.CMD = "SELECT ":FN.REDO.ISSUE.CLAIMS
    SEL.REQ.CMD = "SELECT ":FN.REDO.ISSUE.REQUESTS
    SEL.COMP.CMD = "SELECT ":FN.REDO.ISSUE.COMPLAINTS

    GOSUB CHECK.PRD.STA.TYPE
    GOSUB CHECK.CUSID.SPRTGRP.OPENCHAN
    GOSUB CHECK.DAO.RISK.GRP
    GOSUB CHECK.OPEN.DATE
    GOSUB CHECK.CLOSE.DATE
    GOSUB CHECK.INPUTTER.SEG

    CALL EB.READLIST(SEL.CLAIMS.CMD,SEL.CLAIMS.LIST,'',NOR.CLAIMS,SEL.CLAIMS.ERR)
    CALL EB.READLIST(SEL.REQ.CMD,SEL.REQ.LIST,'',NOR.REQ,SEL.REQ.ERR)
    CALL EB.READLIST(SEL.COMP.CMD,SEL.COMP.LIST,'',NOR.COMP,SEL.COMP.ERR)

    IF NOR.CLAIMS THEN
        GOSUB CLAIMS.DETAILS
    END
    IF NOR.REQ THEN
        GOSUB REQ.DETAILS
    END
    IF NOR.COMP THEN
        GOSUB COMP.DETAILS
    END
RETURN
*-------------------------------
CHECK.PRD.STA.TYPE:
*-------------------------------
    LOCATE 'PRODUCTO' IN D.FIELDS<1> SETTING Y.PRODUCTO.POS THEN
        VAR.PRODUCTO = D.RANGE.AND.VALUE<Y.PRODUCTO.POS>
        IF VAR.PRODUCTO NE '' THEN
            IF SEL.FIELD EQ 1 THEN
                SEL.CLAIMS.CMD := " AND PRODUCT.TYPE EQ ":VAR.PRODUCTO
                SEL.REQ.CMD := " AND PRODUCT.TYPE EQ ":VAR.PRODUCTO
                SEL.COMP.CMD := " AND PRODUCT.TYPE EQ ":VAR.PRODUCTO
            END ELSE
                SEL.FIELD = 1
                SEL.CLAIMS.CMD := " WITH PRODUCT.TYPE EQ ":VAR.PRODUCTO
                SEL.REQ.CMD    := " WITH PRODUCT.TYPE EQ ":VAR.PRODUCTO
                SEL.COMP.CMD   := " WITH PRODUCT.TYPE EQ ":VAR.PRODUCTO
            END
        END
    END
    LOCATE 'ESTADO.DEL.CASO' IN D.FIELDS<1> SETTING Y.ESTADO.DEL.CASO.POS THEN
        VAR.ESTADO.DEL.CASO = D.RANGE.AND.VALUE<Y.ESTADO.DEL.CASO.POS>
        IF VAR.ESTADO.DEL.CASO NE '' THEN
            IF SEL.FIELD EQ 1 THEN
                SEL.CLAIMS.CMD :=" AND STATUS EQ ":VAR.ESTADO.DEL.CASO
                SEL.REQ.CMD := " AND STATUS EQ ":VAR.ESTADO.DEL.CASO
                SEL.COMP.CMD := " AND STATUS EQ ":VAR.ESTADO.DEL.CASO
            END ELSE
                SEL.FIELD = 1
                SEL.CLAIMS.CMD := " WITH STATUS EQ ":VAR.ESTADO.DEL.CASO
                SEL.REQ.CMD    := " WITH STATUS EQ ":VAR.ESTADO.DEL.CASO
                SEL.COMP.CMD   := " WITH STATUS EQ ":VAR.ESTADO.DEL.CASO
            END
        END
    END
    LOCATE 'TIPO.CASO' IN D.FIELDS<1> SETTING Y.TIPO.CASO.POS THEN
        VAR.TIPO.CASO = D.RANGE.AND.VALUE<Y.TIPO.CASO.POS>
        IF VAR.TIPO.CASO NE '' THEN
            IF SEL.FIELD EQ 1 THEN
                SEL.CLAIMS.CMD := " AND TYPE EQ ":VAR.TIPO.CASO
                SEL.REQ.CMD := " AND TYPE EQ ":VAR.TIPO.CASO
                SEL.COMP.CMD := " AND TYPE EQ ":VAR.TIPO.CASO
            END ELSE
                SEL.FIELD = 1
                SEL.CLAIMS.CMD := " WITH TYPE EQ ":VAR.TIPO.CASO
                SEL.REQ.CMD    := " WITH TYPE EQ ":VAR.TIPO.CASO
                SEL.COMP.CMD   := " WITH TYPE EQ ":VAR.TIPO.CASO
            END
        END
    END
RETURN
*-----------------------------------------------------------------------------------
CHECK.CUSID.SPRTGRP.OPENCHAN:
*----------------------------------------------------------------------------------
    LOCATE 'NUMERO.ID.CLIENTE' IN D.FIELDS<1> SETTING Y.NUMERO.ID.CLIENTE.POS THEN
        VAR.NUMERO.ID.CLIENTE = D.RANGE.AND.VALUE<Y.NUMERO.ID.CLIENTE.POS>
        IF VAR.NUMERO.ID.CLIENTE NE '' THEN
            IF SEL.FIELD EQ 1 THEN
                SEL.CLAIMS.CMD := " AND CUST.ID.NUMBER EQ ":VAR.NUMERO.ID.CLIENTE
                SEL.REQ.CMD := " AND CUST.ID.NUMBER EQ ":VAR.NUMERO.ID.CLIENTE
                SEL.COMP.CMD := " AND CUST.ID.NUMBER EQ ":VAR.NUMERO.ID.CLIENTE
            END ELSE
                SEL.FIELD = 1
                SEL.CLAIMS.CMD := " WITH CUST.ID.NUMBER EQ ":VAR.NUMERO.ID.CLIENTE
                SEL.REQ.CMD    := " WITH CUST.ID.NUMBER EQ ":VAR.NUMERO.ID.CLIENTE
                SEL.COMP.CMD   := " WITH CUST.ID.NUMBER EQ ":VAR.NUMERO.ID.CLIENTE
            END
        END
    END

    LOCATE 'CANAL.DE.APERTURA' IN D.FIELDS<1> SETTING Y.CANAL.DE.APERTURA.POS THEN
        VAR.CANAL.DE.APERTURA = D.RANGE.AND.VALUE<Y.CANAL.DE.APERTURA.POS>
        IF VAR.CANAL.DE.APERTURA NE '' THEN
            IF SEL.FIELD EQ 1 THEN
                SEL.CLAIMS.CMD := " AND OPENING.CHANNEL EQ ":VAR.CANAL.DE.APERTURA
                SEL.REQ.CMD := " AND OPENING.CHANNEL EQ ":VAR.CANAL.DE.APERTURA
                SEL.COMP.CMD := " AND OPENING.CHANNEL EQ ":VAR.CANAL.DE.APERTURA
            END ELSE
                SEL.FIELD = 1
                SEL.CLAIMS.CMD := " WITH OPENING.CHANNEL EQ ":VAR.CANAL.DE.APERTURA
                SEL.REQ.CMD    := " WITH OPENING.CHANNEL EQ ":VAR.CANAL.DE.APERTURA
                SEL.COMP.CMD   := " WITH OPENING.CHANNEL EQ ":VAR.CANAL.DE.APERTURA
            END
        END
    END
    LOCATE 'GRUPO.DE.APOYO' IN D.FIELDS<1> SETTING Y.GRUPO.DE.APOYO.POS THEN
        VAR.GRUPO.DE.APOYO = D.RANGE.AND.VALUE<Y.GRUPO.DE.APOYO.POS>
        IF VAR.GRUPO.DE.APOYO NE '' THEN
            IF SEL.FIELD EQ 1 THEN
                SEL.CLAIMS.CMD := " AND SUPPORT.GROUP EQ ":VAR.GRUPO.DE.APOYO
                SEL.REQ.CMD := " AND SUPPORT.GROUP EQ ":VAR.GRUPO.DE.APOYO
                SEL.COMP.CMD := " AND SUPPORT.GROUP EQ ":VAR.GRUPO.DE.APOYO
            END ELSE
                SEL.FIELD = 1
                SEL.CLAIMS.CMD := " WITH SUPPORT.GROUP EQ ":VAR.GRUPO.DE.APOYO
                SEL.REQ.CMD    := " WITH SUPPORT.GROUP EQ ":VAR.GRUPO.DE.APOYO
                SEL.COMP.CMD   := " WITH SUPPORT.GROUP EQ ":VAR.GRUPO.DE.APOYO
            END
        END
    END
RETURN
*----------------------------------------------------------
CHECK.DAO.RISK.GRP:
*----------------------------------------------------------
    LOCATE 'SUCURSAL' IN D.FIELDS<1> SETTING Y.SUCURSAL.POS THEN
        VAR.SUCURSAL = D.RANGE.AND.VALUE<Y.SUCURSAL.POS>
        IF VAR.SUCURSAL NE '' THEN
            IF SEL.FIELD EQ 1 THEN
                SEL.CLAIMS.CMD := " AND BRANCH EQ ":VAR.SUCURSAL
                SEL.REQ.CMD := " AND BRANCH EQ ":VAR.SUCURSAL
                SEL.COMP.CMD := " AND BRANCH EQ ":VAR.SUCURSAL
            END ELSE
                SEL.FIELD = 1
                SEL.CLAIMS.CMD := " WITH BRANCH EQ ":VAR.SUCURSAL
                SEL.REQ.CMD    := " WITH BRANCH EQ ":VAR.SUCURSAL
                SEL.COMP.CMD   := " WITH BRANCH EQ ":VAR.SUCURSAL
            END
        END
    END

    LOCATE 'OFICIAL' IN D.FIELDS<1> SETTING Y.OFICIAL.POS THEN
        VAR.OFICIAL = D.RANGE.AND.VALUE<Y.OFICIAL.POS>
        IF VAR.OFICIAL NE '' THEN
            IF SEL.FIELD EQ 1 THEN
                SEL.CLAIMS.CMD := " AND ACCOUNT.OFFICER EQ ":VAR.OFICIAL
                SEL.REQ.CMD := " AND ACCOUNT.OFFICER EQ ":VAR.OFICIAL
                SEL.COMP.CMD := " AND ACCOUNT.OFFICER EQ ":VAR.OFICIAL
            END ELSE
                SEL.FIELD = 1
                SEL.CLAIMS.CMD := " WITH ACCOUNT.OFFICER EQ ":VAR.OFICIAL
                SEL.REQ.CMD    := " WITH ACCOUNT.OFFICER EQ ":VAR.OFICIAL
                SEL.COMP.CMD   := " WITH ACCOUNT.OFFICER EQ ":VAR.OFICIAL
            END
        END
    END
    LOCATE 'NIVEL.DE.RIESGO' IN D.FIELDS<1> SETTING Y.NIVEL.DE.RIESGO.POS THEN
        VAR.NIVEL.DE.RIESGO = D.RANGE.AND.VALUE<Y.NIVEL.DE.RIESGO.POS>
        IF VAR.NIVEL.DE.RIESGO NE '' THEN
            IF SEL.FIELD EQ 1 THEN
                SEL.CLAIMS.CMD := " AND RISK.LEVEL EQ ":VAR.NIVEL.DE.RIESGO
                SEL.REQ.CMD := " AND RISK.LEVEL EQ ":VAR.NIVEL.DE.RIESGO
                SEL.COMP.CMD := " AND RISK.LEVEL EQ ":VAR.NIVEL.DE.RIESGO
            END ELSE
                SEL.FIELD = 1
                SEL.CLAIMS.CMD := " WITH RISK.LEVEL EQ ":VAR.NIVEL.DE.RIESGO
                SEL.REQ.CMD    := " WITH RISK.LEVEL EQ ":VAR.NIVEL.DE.RIESGO
                SEL.COMP.CMD   := " WITH RISK.LEVEL EQ ":VAR.NIVEL.DE.RIESGO
            END
        END
    END

RETURN
*------------------------------------------------------------------------------------------------
CHECK.OPEN.DATE:
*--------------------------------------------------------------------------------------------------
    LOCATE 'FECHA.APERTU.DESDE' IN D.FIELDS<1> SETTING Y.FECHA.APERTU.DESDE.POS THEN
        VAR.FECHA.APERTU.DESDE = D.RANGE.AND.VALUE<Y.FECHA.APERTU.DESDE.POS>
        IF VAR.FECHA.APERTU.DESDE NE '' THEN
            IF SEL.FIELD EQ 1 THEN
                SEL.CLAIMS.CMD := " AND OPENING.DATE GE ":VAR.FECHA.APERTU.DESDE
                SEL.REQ.CMD := " AND OPENING.DATE GE ":VAR.FECHA.APERTU.DESDE
                SEL.COMP.CMD :=" AND OPENING.DATE GE ":VAR.FECHA.APERTU.DESDE
            END ELSE
                SEL.FIELD = 1
                SEL.CLAIMS.CMD := " WITH OPENING.DATE GE ":VAR.FECHA.APERTU.DESDE
                SEL.REQ.CMD    := " WITH OPENING.DATE GE ":VAR.FECHA.APERTU.DESDE
                SEL.COMP.CMD   := " WITH OPENING.DATE GE ":VAR.FECHA.APERTU.DESDE
            END
        END
    END
    LOCATE 'FECHA.APERTU.HASTA' IN D.FIELDS<1> SETTING Y.FECHA.APERTU.HASTA.POS THEN
        VAR.FECHA.APERTU.HASTA = D.RANGE.AND.VALUE<Y.FECHA.APERTU.HASTA.POS>
        IF VAR.FECHA.APERTU.HASTA NE '' THEN
            IF SEL.FIELD EQ 1 THEN
                SEL.CLAIMS.CMD := " AND OPENING.DATE LE ":VAR.FECHA.APERTU.HASTA
                SEL.REQ.CMD :=" AND OPENING.DATE LE ":VAR.FECHA.APERTU.HASTA
                SEL.COMP.CMD := " AND OPENING.DATE LE ":VAR.FECHA.APERTU.HASTA
            END ELSE
                SEL.FIELD = 1
                SEL.CLAIMS.CMD := " WITH OPENING.DATE LE ":VAR.FECHA.APERTU.HASTA
                SEL.REQ.CMD    := " WITH OPENING.DATE LE ":VAR.FECHA.APERTU.HASTA
                SEL.COMP.CMD   := " WITH OPENING.DATE LE ":VAR.FECHA.APERTU.HASTA
            END
        END
    END
RETURN
*--------------------------------------------------------------------------------------------------
CHECK.CLOSE.DATE:
*--------------------------------------------------------------------------------------------------
    LOCATE 'FECHA.CIERRE.DESDE' IN D.FIELDS<1> SETTING Y.FECHA.CIERRE.DESDE.POS THEN
        VAR.FECHA.CIERRE.DESDE = D.RANGE.AND.VALUE<Y.FECHA.CIERRE.DESDE.POS>
        IF VAR.FECHA.CIERRE.DESDE NE '' THEN
            IF SEL.FIELD EQ 1 THEN
                SEL.CLAIMS.CMD := " AND CLOSING.DATE GE ":VAR.FECHA.CIERRE.DESDE
                SEL.REQ.CMD := " AND CLOSING.DATE GE ":VAR.FECHA.CIERRE.DESDE
                SEL.COMP.CMD := " AND CLOSING.DATE GE ":VAR.FECHA.CIERRE.DESDE
            END ELSE
                SEL.FIELD = 1
                SEL.CLAIMS.CMD := " WITH CLOSING.DATE GE ":VAR.FECHA.CIERRE.DESDE
                SEL.REQ.CMD    := " WITH CLOSING.DATE GE ":VAR.FECHA.CIERRE.DESDE
                SEL.COMP.CMD   := " WITH CLOSING.DATE GE ":VAR.FECHA.CIERRE.DESDE
            END
        END
    END
    LOCATE 'FECHA.CIERRE.HASTA' IN D.FIELDS<1> SETTING Y.FECHA.CIERRE.HASTA.POS THEN
        VAR.FECHA.CIERRE.HASTA = D.RANGE.AND.VALUE<Y.FECHA.CIERRE.HASTA.POS>
        IF VAR.FECHA.CIERRE.HASTA NE '' THEN
            IF SEL.FIELD EQ 1 THEN
                SEL.CLAIMS.CMD := " AND CLOSING.DATE LE ":VAR.FECHA.CIERRE.HASTA
                SEL.REQ.CMD := " AND CLOSING.DATE LE ":VAR.FECHA.CIERRE.HASTA
                SEL.COMP.CMD := " AND CLOSING.DATE LE ":VAR.FECHA.CIERRE.HASTA
            END ELSE
                SEL.FIELD = 1
                SEL.CLAIMS.CMD := " WITH CLOSING.DATE LE ":VAR.FECHA.CIERRE.HASTA
                SEL.REQ.CMD    := " WITH CLOSING.DATE LE ":VAR.FECHA.CIERRE.HASTA
                SEL.COMP.CMD   := " WITH CLOSING.DATE LE ":VAR.FECHA.CIERRE.HASTA
            END
        END
    END
RETURN
*--------------------------------------------------------------------------------------------------
CHECK.INPUTTER.SEG:
*--------------------------------------------------------------------------------------------------
    LOCATE 'USUARIO.ABRE.CASO' IN D.FIELDS<1> SETTING Y.USUARIO.ABRE.CASO.POS THEN
        VAR.USUARIO.ABRE.CASO = D.RANGE.AND.VALUE<Y.USUARIO.ABRE.CASO.POS>
        IF VAR.USUARIO.ABRE.CASO THEN
            Y.INPUTTER.FLAG = 'Y'
        END
    END
    LOCATE 'SEGMENTO.CLIENTE' IN D.FIELDS<1> SETTING Y.SEGMENTO.CLIENTE.POS THEN
        VAR.SEGMENTO.CLIENTE = D.RANGE.AND.VALUE<Y.SEGMENTO.CLIENTE.POS>
        IF VAR.SEGMENTO.CLIENTE THEN
            Y.SEGMENTO.FLAG = 'Y'
        END
    END
RETURN
*-------------------------------------------------------------------------------------------------
CLAIMS.DETAILS:
*---------------------------------------------------------------------------------------------------
    Y.CLAIMS.COUNT = DCOUNT(SEL.CLAIMS.LIST,@FM)
    Y.CLAIMS.LOOP = 1
    LOOP
    WHILE Y.CLAIMS.LOOP LE Y.CLAIMS.COUNT
        CLAIMS.ID = SEL.CLAIMS.LIST<Y.CLAIMS.LOOP> ; Y.INPUT.FLAG = '' ; Y.SEG.FLAG = '' ; Y.VAR.STATUS = '' ; Y.VAR.TYPE = ''
        CALL F.READ(FN.REDO.ISSUE.CLAIMS,CLAIMS.ID,R.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS,CLAIM.ER)
        Y.CUST.ID = R.REDO.ISSUE.CLAIMS<ISS.CL.CUSTOMER.CODE>
        VAR.STATUS = R.REDO.ISSUE.CLAIMS<ISS.CL.STATUS>
        IF VAR.STATUS EQ 'RESOLVED-ACCEPTED' OR VAR.STATUS EQ 'RESOLVED-REJECTED' THEN
            Y.VAR.STATUS = 'Y'
        END
        VAR.TYPE = R.REDO.ISSUE.CLAIMS<ISS.CL.TYPE>
        IF NOT(VAR.TYPE) THEN
            Y.VAR.TYPE = 'Y'
        END
        R.CUST                     = '' ; CUST.ERR      = ''
        CALL F.READ(FN.CUSTOMER,Y.CUST.ID,R.CUST,F.CUSTOMER,CUST.ERR)
        Y.SEGMENTO =  R.CUST<EB.CUS.LOCAL.REF,POS.L.CU.SEG>     ;*******************5th Field
        Y.TIPO.CL  =  R.CUST<EB.CUS.LOCAL.REF,POS.TIPO.CL>
        Y.INPUTTER  = FIELD(R.REDO.ISSUE.CLAIMS<ISS.CL.INPUTTER>,'_',2)   ;*******************23rd Field
        IF Y.INPUTTER.FLAG EQ 'Y' THEN
            IF Y.INPUTTER EQ VAR.USUARIO.ABRE.CASO ELSE
                Y.INPUT.FLAG = 'Y'
            END
        END
        IF Y.SEGMENTO.FLAG EQ 'Y' THEN
            IF Y.SEGMENTO EQ VAR.SEGMENTO.CLIENTE ELSE
                Y.SEG.FLAG = 'Y'
            END
        END
        IF Y.INPUT.FLAG NE 'Y' AND Y.SEG.FLAG NE 'Y' AND Y.VAR.TYPE NE 'Y' AND Y.VAR.STATUS NE 'Y' THEN
            GOSUB CLAIMS.FIELD.DETAILS
            GOSUB FORM.ARRAY
        END
        Y.CLAIMS.LOOP + =1
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------------
CLAIMS.FIELD.DETAILS:
*--------------------------------------------------------------------------------------------------
    Y.PRODUCT.TYPE.ID=R.REDO.ISSUE.CLAIMS<ISS.CL.PRODUCT.TYPE>
    CALL F.READ(FN.REDO.U.CRM.PRODUCT.TYPE,Y.PRODUCT.TYPE.ID,R.CRM.PDT.TYPE,F.REDO.U.CRM.PRODUCT.TYPE,PDT.TYPE.ERR)
    Y.PRODUCT.TYPE = R.CRM.PDT.TYPE<PRD.TYPE.DESCRIPTION>     ;**********************1st Field
    Y.STATUS=R.REDO.ISSUE.CLAIMS<ISS.CL.STATUS>     ;**********************2nd Field
    Y.OPEN.DATE=R.REDO.ISSUE.CLAIMS<ISS.CL.OPENING.DATE>      ;**********************3rd Field
    Y.TYPE=R.REDO.ISSUE.CLAIMS<ISS.CL.TYPE>         ;*******************4th Field
    IF Y.TIPO.CL EQ 'PERSONA FISICA' OR Y.TIPO.CL EQ 'CLIENTE MENOR' THEN
        Y.GIVEN.NAME = R.REDO.ISSUE.CLAIMS<ISS.CL.GIVEN.NAMES>
        Y.FAMILY.NAME= R.REDO.ISSUE.CLAIMS<ISS.CL.FAMILY.NAMES>
        Y.CUSTOMER.NAME = Y.GIVEN.NAME:" ":Y.FAMILY.NAME        ;*******************6th Field
    END ELSE
        IF Y.TIPO.CL EQ 'PERSONA JURIDICA' THEN
            Y.CUSTOMER.NAME = R.REDO.ISSUE.CLAIMS<ISS.CL.SOCIAL.NAME>       ;*******************6th Field
        END
    END
    Y.CUST.ID.NO =  R.REDO.ISSUE.CLAIMS<ISS.CL.CUST.ID.NUMBER>          ;*******************7th Field
    Y.ACCT.ID = R.REDO.ISSUE.CLAIMS<ISS.CL.ACCOUNT.ID>        ;*******************8th Field
    GOSUB CHECK.PREV.ACCT
    Y.SUPP.GROUP = R.REDO.ISSUE.CLAIMS<ISS.CL.SUPPORT.GROUP>  ;*******************22nd Field
    Y.OPENING.CHANNEL = R.REDO.ISSUE.CLAIMS<ISS.CL.OPENING.CHANNEL>     ;*******************24th Field
    VAR.START.CHANNEL = Y.OPENING.CHANNEL:'-':Y.SEGMENTO
    Y.SLA.ID  = Y.TYPE:'-':Y.PRODUCT.TYPE.ID
    GOSUB CHECK.SEG.DAYS
    Y.CLOSING.DATE = R.REDO.ISSUE.CLAIMS<ISS.CL.CLOSING.DATE> ;*******************11th field
    GOSUB CHECK.SER.DURATION
    Y.CLAIM.TYPE.ID = R.REDO.ISSUE.CLAIMS<ISS.CL.CLAIM.TYPE>
    CALL F.READ(FN.REDO.U.CRM.CLAIM.TYPE,Y.CLAIM.TYPE.ID,R.CLAIM.TYPE,F.REDO.U.CRM.CLAIM.TYPE,CLAIM.TYPE.ERR)
    Y.CLAIM.TYPE = R.CLAIM.TYPE<CLAIM.TYPE.DESCRIPTION>       ;*******************12th field
    Y.AMOUNT.CLAIM = R.REDO.ISSUE.CLAIMS<ISS.CL.AMOUNT.CLAIM> ;*******************13th field
    Y.AMT.PAID = R.REDO.ISSUE.CLAIMS<ISS.CL.AMT.PAID>         ;*******************14th field
    Y.NOTIFY.DATE = R.REDO.ISSUE.CLAIMS<ISS.CL.DATE.NOTIFICATION>       ;*******************15th field
    GOSUB CHECK.NOTIFY.OPEN
    GOSUB CHECK.NOTIFY.CLOSE
    Y.SER.AGR.COMP = R.REDO.ISSUE.CLAIMS<ISS.CL.SER.AGR.COMP> ;*************************19th Field
    Y.BRANCH=R.REDO.ISSUE.CLAIMS<ISS.CL.BRANCH>     ;*************************20th Field
    Y.ACCT.OFFICER = R.REDO.ISSUE.CLAIMS<ISS.CL.ACCOUNT.OFFICER>        ;*************************21st Field
    Y.RISK.LEVEL = R.REDO.ISSUE.CLAIMS<ISS.CL.RISK.LEVEL>     ;*************************25th Field
RETURN
*-------------------------------------------------------------------------------------------------
REQ.DETAILS:
*---------------------------------------------------------------------------------------------------
    Y.REQ.COUNT = DCOUNT(SEL.REQ.LIST,@FM)
    Y.REQ.LOOP = 1
    LOOP
    WHILE Y.REQ.LOOP LE Y.REQ.COUNT
        REQ.ID = SEL.REQ.LIST<Y.REQ.LOOP>  ; Y.INPUT.FLAG = '' ; Y.SEG.FLAG = '' ; Y.VAR.STATUS = '' ; Y.VAR.TYPE = ''
        CALL F.READ(FN.REDO.ISSUE.REQUESTS,REQ.ID,R.REDO.ISSUE.REQ,F.REDO.ISSUE.REQUESTS,REQ.ER)
        Y.CUST.ID = R.REDO.ISSUE.REQ<ISS.REQ.CUSTOMER.CODE>
        VAR.STATUS = R.REDO.ISSUE.REQ<ISS.REQ.STATUS>
        IF VAR.STATUS EQ 'RESOLVED-ACCEPTED' OR VAR.STATUS EQ 'RESOLVED-REJECTED' THEN
            Y.VAR.STATUS = 'Y'
        END
        VAR.TYPE = R.REDO.ISSUE.REQ<ISS.REQ.TYPE>
        IF NOT(VAR.TYPE) THEN
            Y.VAR.TYPE = 'Y'
        END
        R.CUST                     = '' ; CUST.ERR      = ''
        CALL F.READ(FN.CUSTOMER,Y.CUST.ID,R.CUST,F.CUSTOMER,CUST.ERR)
        Y.SEGMENTO =  R.CUST<EB.CUS.LOCAL.REF,POS.L.CU.SEG>     ;*******************5th Field
        Y.TIPO.CL  =  R.CUST<EB.CUS.LOCAL.REF,POS.TIPO.CL>
        Y.INPUTTER  = FIELD(R.REDO.ISSUE.REQ<ISS.REQ.INPUTTER>,'_',2)     ;*******************23rd Field
        IF Y.INPUTTER.FLAG EQ 'Y' THEN
            IF Y.INPUTTER EQ VAR.USUARIO.ABRE.CASO ELSE
                Y.INPUT.FLAG = 'Y'
            END
        END
        IF Y.SEGMENTO.FLAG EQ 'Y' THEN
            IF Y.SEGMENTO EQ VAR.SEGMENTO.CLIENTE ELSE
                Y.SEG.FLAG = 'Y'
            END
        END
        IF Y.INPUT.FLAG NE 'Y' AND Y.SEG.FLAG NE 'Y' AND Y.VAR.STATUS NE 'Y' AND Y.VAR.TYPE NE 'Y' THEN
            GOSUB REQ.FIELD.DETAILS
            GOSUB FORM.ARRAY
        END
        Y.REQ.LOOP + =1
    REPEAT
RETURN
*-------------------------------------------------------------------------------------------------
REQ.FIELD.DETAILS:
*---------------------------------------------------------------------------------------------------
    Y.PRODUCT.TYPE.ID=R.REDO.ISSUE.REQ<ISS.REQ.PRODUCT.TYPE>
    CALL F.READ(FN.REDO.U.CRM.PRODUCT.TYPE,Y.PRODUCT.TYPE.ID,R.CRM.PDT.TYPE,F.REDO.U.CRM.PRODUCT.TYPE,PDT.TYPE.ERR)
    Y.PRODUCT.TYPE = R.CRM.PDT.TYPE<PRD.TYPE.DESCRIPTION>     ;**********************1st Field
    Y.STATUS=R.REDO.ISSUE.REQ<ISS.REQ.STATUS>       ;**********************2nd Field
    Y.OPEN.DATE=R.REDO.ISSUE.REQ<ISS.REQ.OPENING.DATE>        ;**********************3rd Field
    Y.TYPE=R.REDO.ISSUE.REQ<ISS.REQ.TYPE> ;*******************4th Field
    IF Y.TIPO.CL EQ 'PERSONA FISICA' OR Y.TIPO.CL EQ 'CLIENTE MENOR' THEN
        Y.GIVEN.NAME = R.REDO.ISSUE.REQ<ISS.REQ.GIVEN.NAMES>
        Y.FAMILY.NAME= R.REDO.ISSUE.REQ<ISS.REQ.FAMILY.NAMES>
        Y.CUSTOMER.NAME = Y.GIVEN.NAME:" ":Y.FAMILY.NAME        ;*******************6th Field
    END ELSE
        IF Y.TIPO.CL EQ 'PERSONA JURIDICA' THEN
            Y.CUSTOMER.NAME = R.REDO.ISSUE.REQ<ISS.REQ.SOCIAL.NAME>         ;*******************6th Field
        END
    END
    Y.CUST.ID.NO =  R.REDO.ISSUE.REQ<ISS.REQ.CUST.ID.NUMBER>  ;*******************7th Field
    Y.ACCT.ID = R.REDO.ISSUE.REQ<ISS.REQ.ACCOUNT.ID>          ;*******************8th Field
    GOSUB CHECK.PREV.ACCT
    Y.SUPP.GROUP = R.REDO.ISSUE.REQ<ISS.REQ.SUPPORT.GROUP>    ;*******************22nd Field
    Y.OPENING.CHANNEL = R.REDO.ISSUE.REQ<ISS.REQ.OPENING.CHANNEL>       ;*******************24th Field
    VAR.START.CHANNEL = Y.OPENING.CHANNEL:'-':Y.SEGMENTO
    Y.SLA.ID  = Y.TYPE:'-':Y.PRODUCT.TYPE.ID
    GOSUB CHECK.SEG.DAYS
    Y.CLOSING.DATE = R.REDO.ISSUE.REQ<ISS.REQ.CLOSING.DATE>   ;*******************11th field
    GOSUB CHECK.SER.DURATION
    Y.CLAIM.TYPE.ID = R.REDO.ISSUE.REQ<ISS.REQ.CLAIM.TYPE>
    CALL F.READ(FN.REDO.U.CRM.CLAIM.TYPE,Y.CLAIM.TYPE.ID,R.CLAIM.TYPE,F.REDO.U.CRM.CLAIM.TYPE,CLAIM.TYPE.ERR)
    Y.CLAIM.TYPE = R.CLAIM.TYPE<CLAIM.TYPE.DESCRIPTION>       ;*******************12th field
    Y.AMOUNT.CLAIM = ''         ;*******************13th field
    Y.AMT.PAID = ''   ;*******************14th field
    Y.NOTIFY.DATE = R.REDO.ISSUE.REQ<ISS.REQ.DATE.NOTIFICATION>         ;*******************15th field
    GOSUB CHECK.NOTIFY.OPEN
    GOSUB CHECK.NOTIFY.CLOSE
    Y.SER.AGR.COMP = R.REDO.ISSUE.REQ<ISS.REQ.SER.AGR.COMP>   ;*************************19th Field
    Y.BRANCH=R.REDO.ISSUE.REQ<ISS.REQ.BRANCH>       ;*************************20th Field
    Y.ACCT.OFFICER = R.REDO.ISSUE.REQ<ISS.REQ.ACCOUNT.OFFICER>          ;*************************21st Field
    Y.RISK.LEVEL = R.REDO.ISSUE.REQ<ISS.REQ.RISK.LEVEL>       ;*************************25th Field
RETURN
*------------------------------------------------------------------------------------------------------------
COMP.DETAILS:
*---------------------------------------------------------------------------------------------------
    Y.COMP.COUNT = DCOUNT(SEL.COMP.LIST,@FM)
    Y.COMP.LOOP = 1
    LOOP
    WHILE Y.COMP.LOOP LE Y.COMP.COUNT
        COMP.ID = SEL.COMP.LIST<Y.COMP.LOOP>  ; Y.INPUT.FLAG = '' ; Y.SEG.FLAG = '' ; Y.VAR.TYPE = '' ; Y.VAR.STATUS = ''
        CALL F.READ(FN.REDO.ISSUE.COMPLAINTS,COMP.ID,R.REDO.ISSUE.COMP,F.REDO.ISSUE.COMPLAINTS,COMP.ER)
        VAR.TYPE = R.REDO.ISSUE.COMP<ISS.COMP.TYPE>
        VAR.STATUS = R.REDO.ISSUE.COMP<ISS.COMP.STATUS>
        IF VAR.STATUS EQ 'RESOLVED-ACCEPTED' OR VAR.STATUS EQ 'RESOLVED-REJECTED' THEN
            Y.VAR.STATUS = 'Y'
        END
        IF VAR.TYPE EQ "INTERACCION" OR NOT(VAR.TYPE) THEN
            Y.VAR.TYPE = 'Y'
        END
        Y.CUST.ID = R.REDO.ISSUE.COMP<ISS.COMP.CUSTOMER.CODE>
        R.CUST  = '' ; CUST.ERR  = ''
        CALL F.READ(FN.CUSTOMER,Y.CUST.ID,R.CUST,F.CUSTOMER,CUST.ERR)
        Y.SEGMENTO =  R.CUST<EB.CUS.LOCAL.REF,POS.L.CU.SEG>     ;*******************5th Field
        Y.TIPO.CL  =  R.CUST<EB.CUS.LOCAL.REF,POS.TIPO.CL>
        Y.INPUTTER  = FIELD(R.REDO.ISSUE.COMP<ISS.COMP.INPUTTER>,'_',2)   ;*******************23rd Field
        IF Y.INPUTTER.FLAG EQ 'Y' THEN
            IF Y.INPUTTER EQ VAR.USUARIO.ABRE.CASO ELSE
                Y.INPUT.FLAG = 'Y'
            END
        END
        IF Y.SEGMENTO.FLAG EQ 'Y' THEN
            IF Y.SEGMENTO EQ VAR.SEGMENTO.CLIENTE ELSE
                Y.SEG.FLAG = 'Y'
            END
        END
        IF Y.INPUT.FLAG NE 'Y' AND Y.SEG.FLAG NE 'Y' AND Y.VAR.TYPE NE 'Y' AND Y.VAR.STATUS NE 'Y' THEN
            GOSUB COMP.FIELD.DETAILS
            GOSUB FORM.ARRAY
        END
        Y.COMP.LOOP + =1
    REPEAT
RETURN
*-------------------------------------------------------------------------------------------------
COMP.FIELD.DETAILS:
*---------------------------------------------------------------------------------------------------
    Y.PRODUCT.TYPE = 'N/A'      ;**********************1st Field
    Y.STATUS=R.REDO.ISSUE.COMP<ISS.COMP.STATUS>     ;**********************2nd Field
    Y.OPEN.DATE=R.REDO.ISSUE.COMP<ISS.COMP.OPENING.DATE>      ;**********************3rd Field
    Y.TYPE=R.REDO.ISSUE.COMP<ISS.COMP.TYPE>         ;*******************4th Field
    IF Y.TIPO.CL EQ 'PERSONA FISICA' OR Y.TIPO.CL EQ 'CLIENTE MENOR' THEN
        Y.GIVEN.NAME = R.REDO.ISSUE.COMP<ISS.COMP.GIVEN.NAMES>
        Y.FAMILY.NAME= R.REDO.ISSUE.COMP<ISS.COMP.FAMILY.NAMES>
        Y.CUSTOMER.NAME = Y.GIVEN.NAME:" ":Y.FAMILY.NAME        ;*******************6th Field
    END ELSE
        IF Y.TIPO.CL EQ 'PERSONA JURIDICA' THEN
            Y.CUSTOMER.NAME = R.REDO.ISSUE.COMP<ISS.COMP.SOCIAL.NAME>       ;*******************6th Field
        END
    END
    Y.CUST.ID.NO =  R.REDO.ISSUE.COMP<ISS.COMP.CUST.ID.NUMBER>          ;*******************7th Field
    Y.ACCT.ID = 'N/A' ;*******************8th Field
    Y.PREV.ACCOUNT = 'N/A'      ;*******************9th Field
    Y.SUPP.GROUP = R.REDO.ISSUE.COMP<ISS.COMP.SUPPORT.GROUP>  ;*******************22nd Field
    Y.OPENING.CHANNEL = R.REDO.ISSUE.COMP<ISS.COMP.OPENING.CHANNEL>     ;*******************24th Field
    VAR.START.CHANNEL = Y.OPENING.CHANNEL:'-':Y.SEGMENTO
    Y.SLA.ID  = Y.TYPE
    GOSUB CHECK.SEG.DAYS
    Y.CLOSING.DATE = R.REDO.ISSUE.COMP<ISS.COMP.CLOSING.DATE> ;*******************11th field
    GOSUB CHECK.SER.DURATION
    Y.CLAIM.TYPE = 'N/A'        ;*******************12th field
    Y.AMOUNT.CLAIM = ''         ;*******************13th field
    Y.AMT.PAID = ''   ;*******************14th field
    Y.NOTIFY.DATE = R.REDO.ISSUE.COMP<ISS.COMP.DATE.NOTIFICATION>       ;*******************15th field
    GOSUB CHECK.NOTIFY.OPEN
    GOSUB CHECK.NOTIFY.CLOSE
    Y.SER.AGR.COMP = R.REDO.ISSUE.COMP<ISS.COMP.SER.AGR.COMP> ;*************************19th Field
    Y.BRANCH=R.REDO.ISSUE.COMP<ISS.COMP.BRANCH>     ;*************************20th Field
    Y.ACCT.OFFICER = R.REDO.ISSUE.COMP<ISS.COMP.ACCOUNT.OFFICER>        ;*************************21st Field
    Y.RISK.LEVEL = 'N/A'        ;*************************25th Field
RETURN
*---------------------------------------------------------------------------------------------------------------------
FORM.ARRAY:
*-----------------------------------------------------------------------------------------------------------
***********             1              2            3              4            5
    CRM.ARR<-1>= Y.PRODUCT.TYPE:"#":Y.STATUS:"#":Y.OPEN.DATE:"#":Y.TYPE:"#":Y.SEGMENTO
***********           6                    7            8                   9            10                  11
    CRM.ARR:="#":Y.CUSTOMER.NAME:"#":Y.CUST.ID.NO:"#":Y.ACCT.ID:"#":Y.PREV.ACCOUNT:"#":Y.SEG.DAYS:"#":Y.CLOSING.DATE
***********           12             13                 14               15                16                17
    CRM.ARR:="#":Y.CLAIM.TYPE:"#":Y.AMOUNT.CLAIM:"#":Y.AMT.PAID:"#":Y.NOTIFY.DATE:"#":Y.NOTIFY.OPEN:"#":Y.NOTIFY.CLOSE
***********          18                     19             20             21               22              23
    CRM.ARR:="#":Y.SER.DURATION:"#":Y.SER.AGR.COMP:"#":Y.BRANCH:"#":Y.ACCT.OFFICER:"#":Y.SUPP.GROUP:"#":Y.INPUTTER
**********                   24             25
    CRM.ARR:="#":Y.OPENING.CHANNEL:"#":Y.RISK.LEVEL
RETURN
*-----------------------------------------------------------------------------------
CHECK.SER.DURATION:
*-----------------------------------------------------------------------------------
    IF Y.CLOSING.DATE AND Y.OPEN.DATE THEN
        Y.NO.OF.DAYS = 'C'
        CALL CDD('',Y.OPEN.DATE, Y.CLOSING.DATE, Y.NO.OF.DAYS)
        Y.SER.DURATION = Y.NO.OF.DAYS       ;*******************18th field
    END ELSE
        Y.SER.DURATION = ''       ;*******************18th field
    END
RETURN
*-----------------------------------------------------------------------------------
CHECK.NOTIFY.OPEN:
*-----------------------------------------------------------------------------------
    IF Y.NOTIFY.DATE AND Y.OPEN.DATE THEN
        Y.NO.OF.DAYS = 'C'
        CALL CDD('',Y.OPEN.DATE, Y.NOTIFY.DATE, Y.NO.OF.DAYS)
        Y.NOTIFY.OPEN = Y.NO.OF.DAYS        ;*************************16th Field
    END ELSE
        Y.NOTIFY.OPEN = ''        ;*************************16th Field
    END

RETURN
*------------------------------------------------------------------------------------
CHECK.NOTIFY.CLOSE:
*-------------------------------------------------------------------------------------
    IF Y.NOTIFY.DATE AND Y.CLOSING.DATE THEN
        Y.NO.OF.DAYS = 'C'
        CALL CDD('',Y.CLOSING.DATE, Y.NOTIFY.DATE, Y.NO.OF.DAYS)
        Y.NOTIFY.CLOSE = Y.NO.OF.DAYS       ;*************************17th Field
    END ELSE
        Y.NOTIFY.CLOSE = ''       ;*************************17th Field
    END
RETURN
*--------------------------------------------------------------------------------------
CHECK.PREV.ACCT:
*--------------------------------------------------------------------------------------
    Y.PREV.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCT,F.ACCOUNT,ACC.ER)
    Y.ALT.ACCT.TYPE=R.ACCT<AC.ALT.ACCT.TYPE>
    Y.ALT.ACCT.ID=R.ACCT<AC.ALT.ACCT.ID>
    LOCATE 'ALTERNO1' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POS THEN
        Y.PREV.ACCOUNT = Y.ALT.ACCT.ID<1,ALT.TYPE.POS>          ;*******************9th Field
    END
RETURN
*-------------------------------------------------------------------------------------
CHECK.SEG.DAYS:
*-------------------------------------------------------------------------------------
    Y.SEG.DAYS = ''
    CALL F.READ(FN.REDO.SLA,Y.SLA.ID,R.SLA,F.SLA,SLA.ERR)
    VAR.SUPPORT.GROUP.SLA=R.SLA<SLA.SUPPORT.GROUP>
    LOCATE Y.SUPP.GROUP IN VAR.SUPPORT.GROUP.SLA<1,1> SETTING POS.SLA.SUPP.GRP THEN
        VAR.START.CHANNEL.SLA =  R.SLA<SLA.START.CHANNEL,POS.SLA.SUPP.GRP>
        VAR.SEG.DAYS = R.SLA<SLA.SEG.DAYS,POS.SLA.SUPP.GRP>
        CHANGE @SM TO @FM IN VAR.START.CHANNEL.SLA
        CHANGE @SM TO @FM IN VAR.SEG.DAYS
        LOCATE VAR.START.CHANNEL IN VAR.START.CHANNEL.SLA SETTING POS.ST.CHAN THEN
            Y.SEG.DAYS = VAR.SEG.DAYS<POS.ST.CHAN>      ;*******************10th field
        END
    END
RETURN
*-------------------------------------------------------------------------------------
END
