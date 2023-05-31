$PACKAGE APAP.TAM
SUBROUTINE REDO.V.INP.CHK.EXST.CUST
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.V.INP.CHK.EXST.CUST
* ODR NUMBER    : ODR-2009-10-0522
*-------------------------------------------------------------------------

* Description :A validation needs to be done at the time of entering/updating the local table
* campos Listas Restrictivas. The system should check whether the person whose name is being
* added to the list is presently a customer of Bank or not. This is done based on the values
* of Tipo de Documento(Document Type) and Numero Documento (Document no) of the LOCAL.TABLE
* Based on the values of Tipo de Documento (Document Type) and Numero Documento (Document no)
* the system verifies the fields LEGAL.ID, Local Ref field L.CU.CIDENT  and Local ref field
* L.CU.RNC of all existing customer records and throws up an override if the value of Numero
* Documento matches with the existing records

* In parameter : None
* out parameter : None
*-----------------------------------------------------------------------------------------------------
* MODIFICATION HISTORY      NAME                            DEVELOPMENT REFERENCE
* 14-05-2011                Manju.G                            B.77
*
** 18-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 18-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.CUSTOMER ;* R22 Auto conversion
    $INSERT I_F.REDO.RESTRICTIVE.LIST ;* R22 Auto conversion
    $INSERT I_GTS.COMMON ;* R22 Auto conversion

*
    IF V$FUNCTION EQ 'I' OR V$FUNCTION EQ 'R' OR V$FUNCTION EQ 'D' OR V$FUNCTION EQ 'A' THEN
*    IF OFS.VAL.ONLY EQ '' AND MESSAGE EQ '' THEN
        GOSUB INIT
        GOSUB READ
        GOSUB PROCESS
        GOSUB RESTRICT.CONCAT
    END
RETURN
*
*---------------------------------------------------------------------------------------------------------------
*****
INIT:
*****
*
    FN.CUSTOMER='F.CUSTOMER'; F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    FN.REDO.RESTRICT.CUST.CONCAT = 'F.REDO.RESTRICT.CUST.CONCAT'; F.REDO.RESTRICT.CUST.CONCAT = ''
    CALL OPF(FN.REDO.RESTRICT.CUST.CONCAT,F.REDO.RESTRICT.CUST.CONCAT)

    LOC.REF.APP="CUSTOMER"
    LOC.REF.FIELD='L.CU.LISTA.REST'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.REF.POS)

    SEL.CUSTOMER.CMD=''; CUSTOMER.LIST=''; NOR=''; ERR=''
*OVERRIDE.FLAG = ''
    FN.CUSTOMER.L.CU.PASS.NAT = 'F.CUSTOMER.L.CU.PASS.NAT'; F.CUSTOMER.L.CU.PASS.NAT = ''
    CALL OPF(FN.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT)

    FN.CUSTOMER.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'; F.CUSTOMER.L.CU.RNC = ''
    CALL OPF(FN.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC)

    FN.CUSTOMER.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'; F.CUSTOMER.L.CU.CIDENT = ''
    CALL OPF(FN.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT)
RETURN

******
READ:
******
    Y.NATION = ''; Y.DOC.TYPE =''; Y.DOC.NO = ''
    Y.DOC.TYPE=R.NEW(RESTR.LIST.TIPO.DE.DOCUMENTO)
    Y.DOC.NO=R.NEW(RESTR.LIST.NUMERO.DOCUMENTO)
    Y.NATION = R.NEW(RESTR.LIST.NACIONALIDAD)
    V.DOC.TYPE=R.OLD(RESTR.LIST.TIPO.DE.DOCUMENTO)
    V.DOC.NO=R.OLD(RESTR.LIST.NUMERO.DOCUMENTO)
    V.DOC.NO.LAST = R.NEW.LAST(RESTR.LIST.NUMERO.DOCUMENTO)
    V.DOC.TYPE.LAST = R.NEW.LAST(RESTR.LIST.TIPO.DE.DOCUMENTO)
    IF Y.DOC.TYPE EQ 'PASAPORTE' AND NOT(Y.NATION) THEN
        ETEXT='EB-NATION.FIELD.BLANK'
        CALL STORE.END.ERROR
    END
RETURN

*********
PROCESS:
*********
********************************************************************* CHECK R.OLD IS NULL
    IF V.DOC.NO.LAST NE '' OR V.DOC.TYPE.LAST NE '' THEN
        GOSUB PROCESS1
    END

    IF V.DOC.TYPE EQ '' THEN
        GOSUB PROCESS2
    END ELSE
*
******************************************************* CHECK R.OLD AND R.NEW IS DIFFERENT
        GOSUB PROCESS.ELSE
    END
*
*************************************************************************** V$FUNCTUION IS D
    IF V$FUNCTION EQ 'D' OR V$FUNCTION EQ 'R' THEN
        GOSUB PROCESS.DEL
    END
RETURN
*
****
SI:
****
*
    CURR.NO = ''
    CUSTOMER.ID.NEW=CUSTOMER.LIST
    R.CUSTOMER=''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID.NEW,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
*PACS00074021 & PACS00036502 -S
    VAR.OFS.OVERRIDE = OFS$OVERRIDES
    IF VAR.OFS.OVERRIDE<2,1> EQ 'YES' ELSE
        CURR.NO=DCOUNT(R.NEW(RESTR.LIST.OVERRIDE),@VM) + 1
        TEXT='REDO.EXST.CUST.OVERRIDE'
        CALL STORE.OVERRIDE(CURR.NO)
    END
*PACS00074021 & PACS00036502 - E
    R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.REF.POS>='SI'
    CALL F.WRITE(FN.CUSTOMER,CUSTOMER.ID.NEW,R.CUSTOMER)
RETURN
*
***
NO:
***
*
    CUSTOMER.ID.OLD=CUSTOMER.LIST
    R.CUSTOMER = ''; CUSTOMER.ERR = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID.OLD,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.REF.POS> = 'NO'
    CALL F.WRITE(FN.CUSTOMER,CUSTOMER.ID.OLD,R.CUSTOMER)
RETURN
*
****
DEL:
****
*
    CUSTOMER.ID.DEL=CUSTOMER.LIST
    R.CUSTOMER=''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID.DEL,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.REF.POS>='NO'
    CALL F.WRITE(FN.CUSTOMER,CUSTOMER.ID.DEL,R.CUSTOMER)
RETURN
*
*********
PROCESS1:
*********
    IF V.DOC.NO.LAST NE Y.DOC.NO OR V.DOC.TYPE.LAST NE Y.DOC.TYPE THEN
        IF V.DOC.TYPE.LAST EQ "PASAPORTE" THEN
            GOSUB READ.PASSPORT
            IF CUSTOMER.LIST NE '' THEN
                GOSUB NO
            END
        END
        IF V.DOC.TYPE.LAST EQ "CEDULA" THEN
            GOSUB READ.CIDENT
            IF CUSTOMER.LIST NE '' THEN
                GOSUB NO
            END
        END
        IF V.DOC.TYPE.LAST EQ "RNC" THEN
            GOSUB READ.RNC
            IF CUSTOMER.LIST NE '' THEN
                GOSUB NO
            END
        END
    END
RETURN
*********
PROCESS2:
*********
    IF Y.DOC.TYPE EQ "PASAPORTE" THEN
        GOSUB READ.PASSPORT
        IF CUSTOMER.LIST NE '' THEN
            GOSUB SI
        END
    END
    IF Y.DOC.TYPE EQ "CEDULA" THEN
        GOSUB READ.CIDENT
        IF CUSTOMER.LIST NE '' THEN
            GOSUB SI
        END
    END
    IF Y.DOC.TYPE EQ "RNC" THEN
        GOSUB READ.RNC
        IF CUSTOMER.LIST NE '' THEN
            GOSUB SI
        END
    END
RETURN
***************
PROCESS.ELSE:
****************
    IF Y.DOC.TYPE NE V.DOC.TYPE OR Y.DOC.NO NE V.DOC.NO THEN
        IF V.DOC.TYPE EQ "PASAPORTE" THEN
            GOSUB READ.PASSPORT
            IF CUSTOMER.LIST NE '' THEN
                GOSUB NO
            END
        END
        IF V.DOC.TYPE EQ "CEDULA" THEN
            GOSUB READ.CIDENT
            IF CUSTOMER.LIST NE '' THEN
                GOSUB NO
            END
        END
        IF V.DOC.TYPE EQ "RNC" THEN
            GOSUB READ.RNC
            IF CUSTOMER.LIST NE '' THEN
                GOSUB NO
            END
        END
    END
    IF Y.DOC.TYPE EQ "PASAPORTE" THEN
        GOSUB READ.PASSPORT
        IF CUSTOMER.LIST NE '' THEN
            GOSUB SI
        END
    END
    IF Y.DOC.TYPE EQ "CEDULA" THEN
        GOSUB READ.CIDENT
        IF CUSTOMER.LIST NE '' THEN
            GOSUB SI
        END
    END
    IF Y.DOC.TYPE EQ "RNC" THEN
        GOSUB READ.RNC
        IF CUSTOMER.LIST NE '' THEN
            GOSUB SI
        END
    END

RETURN
**************
PROCESS.DEL:
**************
    IF Y.DOC.TYPE EQ "PASAPORTE" THEN
        GOSUB READ.PASSPORT
        IF CUSTOMER.LIST NE '' THEN
            GOSUB DEL
        END
    END
    IF Y.DOC.TYPE EQ "CEDULA" THEN
        GOSUB READ.CIDENT
        IF CUSTOMER.LIST NE '' THEN
            GOSUB DEL
        END
    END
    IF Y.DOC.TYPE EQ "RNC" THEN
        GOSUB READ.RNC
        IF CUSTOMER.LIST NE '' THEN
            GOSUB DEL
        END
    END
RETURN

RESTRICT.CONCAT:
****************
    YIDENT.VAL = ''
    IF Y.DOC.TYPE EQ 'PASAPORTE' THEN
        YIDENT.VAL = Y.DOC.NO:'-':Y.NATION
    END ELSE
        YIDENT.VAL = Y.DOC.NO
    END
    GOSUB READ.RESTRICT.LST
    IF V$FUNCTION EQ 'I' THEN
        IF R.REDO.RESTRICT.CUST.CONCAT THEN
            LOCATE ID.NEW IN R.REDO.RESTRICT.CUST.CONCAT SETTING YFM ELSE
                R.REDO.RESTRICT.CUST.CONCAT<-1> = ID.NEW
                GOSUB WRITE.RESTRICT.LST
            END
        END ELSE
            R.REDO.RESTRICT.CUST.CONCAT<-1> = ID.NEW
            GOSUB WRITE.RESTRICT.LST
        END
    END

    YGRP.CNT = 0
    IF (V$FUNCTION EQ 'R' OR V$FUNCTION EQ 'D') AND R.REDO.RESTRICT.CUST.CONCAT NE '' THEN
        YGRP.CNT = DCOUNT(R.REDO.RESTRICT.CUST.CONCAT,@FM)
        IF YGRP.CNT EQ 1 THEN
            DELETE F.REDO.RESTRICT.CUST.CONCAT,YIDENT.VAL
        END ELSE
            GOSUB FIN.REST.VAL
        END
    END
RETURN

FIN.REST.VAL:
***********
    LOCATE ID.NEW IN R.REDO.RESTRICT.CUST.CONCAT SETTING YFM.POS THEN
        DEL R.REDO.RESTRICT.CUST.CONCAT<YFM.POS>
        GOSUB WRITE.RESTRICT.LST
    END
RETURN

READ.RESTRICT.LST:
******************
    ERR.REDO.RESTRICT.CUST.CONCAT = ''; R.REDO.RESTRICT.CUST.CONCAT = ''
    CALL F.READ(FN.REDO.RESTRICT.CUST.CONCAT,YIDENT.VAL,R.REDO.RESTRICT.CUST.CONCAT,F.REDO.RESTRICT.CUST.CONCAT,ERR.REDO.RESTRICT.CUST.CONCAT)
RETURN

WRITE.RESTRICT.LST:
*******************
    CALL F.WRITE(FN.REDO.RESTRICT.CUST.CONCAT,YIDENT.VAL,R.REDO.RESTRICT.CUST.CONCAT)
RETURN

READ.CIDENT:
************
    ERR.CUSTOMER.L.CU.CIDENT = ''; R.CUSTOMER.L.CU.CIDENT = ''; CUSTOMER.LIST = ''
    CALL F.READ(FN.CUSTOMER.L.CU.CIDENT,Y.DOC.NO,R.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT,ERR.CUSTOMER.L.CU.CIDENT)
    IF R.CUSTOMER.L.CU.CIDENT THEN
        CUSTOMER.LIST = FIELD(R.CUSTOMER.L.CU.CIDENT,'*',2)
    END
RETURN

READ.RNC:
*********
    ERR.CUSTOMER.L.CU.RNC = ''; R.CUSTOMER.L.CU.RNC = ''; CUSTOMER.LIST = ''
    CALL F.READ(FN.CUSTOMER.L.CU.RNC,Y.DOC.NO,R.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC,ERR.CUSTOMER.L.CU.RNC)
    IF R.CUSTOMER.L.CU.RNC THEN
        CUSTOMER.LIST = FIELD(R.CUSTOMER.L.CU.RNC,'*',2)
    END
RETURN

READ.PASSPORT:
**************
    ERR.CUSTOMER.L.CU.PASS.NAT = ''; R.CUSTOMER.L.CU.PASS.NAT = ''; CUSTOMER.LIST = ''; YCUST.ID = ''
    YCUST.ID = Y.DOC.NO:'-':Y.NATION
    CALL F.READ(FN.CUSTOMER.L.CU.PASS.NAT,YCUST.ID,R.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT,ERR.CUSTOMER.L.CU.PASS.NAT)
    IF R.CUSTOMER.L.CU.PASS.NAT THEN
        CUSTOMER.LIST = FIELD(R.CUSTOMER.L.CU.PASS.NAT,'*',2)
    END
RETURN
*------------------------------------------------------------------------------------------------------------------------
END
