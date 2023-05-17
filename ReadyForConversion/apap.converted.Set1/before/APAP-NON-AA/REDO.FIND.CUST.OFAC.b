*-----------------------------------------------------------------------------
* <Rating>-129</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.FIND.CUST.OFAC(OFAC.TIPO.CL,Y.CUST.NAME,OFAC.GIVEN.NAMES,OFAC.FAMILY.NAME,OFAC.CUS.NAME1,OFAC.CUS.NAME2,OFAC.CUS.TEXT,OFAC.RET)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.OFAC.DBCM
    $INSERT I_F.REDO.INTERFACE.ACT
    $INSERT I_F.REDO.INTERFACE.ACT.DETAILS
    $INSERT JBC.h

    GOSUB INITIALISE.OFAC
    GOSUB OPEN.OFAC.FILES
    GOSUB PREPARE.OFAC
    GOSUB CALL.OFAC

    RETURN

INITIALISE.OFAC:
    KEY1="123456"
    IPADD.DESC = ''
    PORT.DESC = ''
    DBNAME.DESC = ''
    TBNAME.DESC = ''
    USER.DESC = ''
    PWD.DESC = ''
    PARAM1 = ''
    PARAM2 = ''
    PARAM3 = ''
    PARAM4 = ''
    PARAM5 = ''
    PARAM6 = ''
    PARAM7 = ''
    PARAM8 = ''
    PARAM9 = ''
    PARAM10 = ''
    PARAM11 = ''
    PARAM12 = ''
    MSG1 = ''
    MSG2 = ''
    REF.POS = ''
    ALLPARAM = ''
    ret = ""
    ERR = ""
    REDO.OFAC.DBCM.ID = "SYSTEM"

    INT.CODE = 'C9001'
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ID.NEW
    MON.TP = '03'
    REC.CON = ''
    EX.USER = ''
    EX.PC = ''

    MARK.NAME.2 = 'N'
    Y.PARAM.VAL.NO = ''
    Y.PARAM1 = ''
    Y.PARAM.NEW = ''
    Y.CNT = ''

    INT.ID = ''
    Y.DATE = OCONV(DATE(), 'DD')
    Y.DATE = STR('0', 2-LEN(Y.DATE)):Y.DATE
    Y.YEAR = OCONV(DATE(), 'DY4')
    Y.MONTH = OCONV(DATE(), 'DM')
    Y.MONTH = STR('0', 2-LEN(Y.MONTH)):Y.MONTH
    Y.HOUR=OCONV(TIME(), 'MTS')[1,2]
    Y.MINUTE = OCONV(TIME(), 'MTS')[4,2]
    Y.SECOND = OCONV(TIME(), 'MTS')[7,2]
    Y.CONT=''
    INT.CODE.REC=''
    Y.MSG=''

    RETURN

OPEN.OFAC.FILES:
    FN.REDO.OFAC.DBCM = 'F.REDO.OFAC.DBCM'
    F.REDO.OFAC.DBCM = ''
    CALL OPF(FN.REDO.OFAC.DBCM,F.REDO.OFAC.DBCM)

    FN.REDO.INTERFACE.ACT = 'F.REDO.INTERFACE.ACT'
    F.REDO.INTERFACE.ACT = ''
    CALL OPF(FN.REDO.INTERFACE.ACT,F.REDO.INTERFACE.ACT)

    FN.REDO.INTERFACE.ACT.DETAILS = 'F.REDO.INTERFACE.ACT.DETAILS'
    F.REDO.INTERFACE.ACT.DETAILS = ''
    CALL OPF(FN.REDO.INTERFACE.ACT.DETAILS,F.REDO.INTERFACE.ACT.DETAILS)

    RETURN

PREPARE.OFAC:
    CALL CACHE.READ(FN.REDO.OFAC.DBCM,REDO.OFAC.DBCM.ID,R.REDO.OFAC.DBCM,ERR.REDO.OFAC.DBCM)

* 20170217 /S
*    IPADD.DESC = DECRYPT(R.REDO.OFAC.DBCM<REDO.DBCM.IP.ADD>,KEY1,JBASE_CRYPT_DES)
*    PORT.DESC = DECRYPT(R.REDO.OFAC.DBCM<REDO.DBCM.PORT>,KEY1,JBASE_CRYPT_DES)
*    DBNAME.DESC = DECRYPT(R.REDO.OFAC.DBCM<REDO.DBCM.DB.NAME>,KEY1,JBASE_CRYPT_DES)
*    TBNAME.DESC = DECRYPT(R.REDO.OFAC.DBCM<REDO.DBCM.TB.NAME>,KEY1,JBASE_CRYPT_DES)
*    USER.DESC = DECRYPT(R.REDO.OFAC.DBCM<REDO.DBCM.DB.USER>,KEY1,JBASE_CRYPT_DES_BASE64)
*    PWD.DESC = DECRYPT(R.REDO.OFAC.DBCM<REDO.DBCM.DB.PWD>,KEY1,JBASE_CRYPT_DES_BASE64)

    IPADD.DESC = R.REDO.OFAC.DBCM<REDO.DBCM.IP.ADD>
    PORT.DESC = R.REDO.OFAC.DBCM<REDO.DBCM.PORT>
    DBNAME.DESC = R.REDO.OFAC.DBCM<REDO.DBCM.DB.NAME>
    TBNAME.DESC = R.REDO.OFAC.DBCM<REDO.DBCM.TB.NAME>
    USER.DESC = R.REDO.OFAC.DBCM<REDO.DBCM.DB.USER>
    PWD.DESC = R.REDO.OFAC.DBCM<REDO.DBCM.DB.PWD>
* 20170217 /E

    PARAM1 = IPADD.DESC
    PARAM2 = PORT.DESC
    PARAM3 = DBNAME.DESC
    PARAM4 = TBNAME.DESC
    PARAM5 = USER.DESC
    PARAM6 = PWD.DESC
    PARAM7 = R.REDO.OFAC.DBCM<REDO.DBCM.EMAIL.REQ.DIR>
    PARAM8 = R.REDO.OFAC.DBCM<REDO.DBCM.EMAIL.TO.ADD>
*CONVERT VM TO '/' IN PARAM8
* Change CONVERT for CHANGE, suggested by Lakshmanan Venkatachalam
    CHANGE VM TO '/' IN PARAM8
    MSG1 = R.REDO.OFAC.DBCM<REDO.DBCM.MSG.IF.EX.CU>
    MSG2 = R.REDO.OFAC.DBCM<REDO.DBCM.MSG.IF.DB.ER>
    PARAM11 = R.REDO.OFAC.DBCM<REDO.DBCM.STORE.PROC.NAME>
    PARAM12 = R.REDO.OFAC.DBCM<REDO.DBCM.EMAIL.FROM.ADD>

* msth 20140120: APAP documentation refers to pass WS Customer.Name directly
* msth 20140120: this is different than REDO.FIND.OFAC standard code
* msth 20140120: code is left in case APAP opt for standard code

*IF OFAC.TIPO.CL EQ "PERSONA FISICA" OR OFAC.TIPO.CL EQ "CLIENTE MENOR" THEN
*PF='Y'
*END ELSE
*IF OFAC.TIPO.CL EQ "PERSONA JURIDICA" THEN
    PF='N'
*END
*END

* msth 20140121: D.RANGE.AND.VALUE seems to need this
    EQU SVM TO CHAR(252)
    CHANGE SVM TO ' ' IN Y.CUST.NAME

    PARAM9 = Y.CUST.NAME
    Y.PARAM1 = PARAM9
    GOSUB FORM.SQLPARAM
    PARAM9 = Y.PARAM1
    PARAM10 = PARAM9

    GOSUB PARAM.CHECK1

    PARAM10 = ''

*IF OFAC.TIPO.CL EQ "PERSONA FISICA" OR OFAC.TIPO.CL EQ "CLIENTE MENOR" THEN
*    PARAM9 = OFAC.GIVEN.NAMES
*
*    Y.PARAM1 = PARAM9
*    GOSUB FORM.SQLPARAM
*    PARAM9 = Y.PARAM1
*
*    PARAM10 = OFAC.FAMILY.NAME
*    Y.PARAM1 = PARAM10
*    GOSUB FORM.SQLPARAM
*    PARAM10 = Y.PARAM1
*
*    Y.TEMP = PARAM9
*    PARAM9 = PARAM10
*    PARAM10 = Y.TEMP
*
*    PF='Y'
*    GOSUB PARAM.CHECK1
*
*END ELSE
*
*    IF OFAC.TIPO.CL EQ "PERSONA JURIDICA" THEN
*        IF MARK.NAME.2 EQ "N" THEN
*            PARAM9 = OFAC.CUS.NAME1
*            MARK.NAME.2 = "Y"
*        END ELSE
*            PARAM9 = OFAC.CUS.NAME2
*            MARK.NAME.2 = ""
*        END
*
*        Y.PARAM1 = PARAM9
*        GOSUB FORM.SQLPARAM
*        PARAM9 = Y.PARAM1
*
*        PARAM10 = OFAC.CUS.TEXT
*        Y.PARAM1 = PARAM10
*        GOSUB FORM.SQLPARAM
*        PARAM10 = Y.PARAM1
*
*        PF='N'
*        GOSUB PARAM.CHECK2
*    END
*END

    SEL.CMD='SELECT ':FN.REDO.INTERFACE.ACT
    SEL.CMD:=' WITH ID.INTERFACE = ':INT.CODE

    CALL EB.READLIST(SEL.CMD, Y.REDO.INTERFACE.ACT.SELLIST, '', NO.REC, ER.SEL)

    INT.ID = Y.REDO.INTERFACE.ACT.SELLIST<1>

    ALLPARAM = PARAM1:",":PARAM2:",":PARAM3:",":PARAM4:",":PARAM5:",":PARAM6:",":PARAM7:",":PARAM8:",":PARAM9:",":PARAM10:",":PF:",":MSG2:",":PARAM11:",":PARAM12

    RETURN

CALL.OFAC:
    className = "com.temenos.redo.ofac"
    methodName = "searchCusOfac"
    CALLJ className, methodName, ALLPARAM SETTING ret ON ERROR GOSUB ERROR.HANDLER.OFAC
    BEGIN CASE
    CASE ret = 1
        OFAC.RET = 'YES'
    CASE ret = 0
        OFAC.RET = 'NO'
    CASE @TRUE
        OFAC.RET = ''
    END CASE

    RETURN

ERROR.HANDLER.OFAC:
    ERR = SYSTEM(0)
    BEGIN CASE
    CASE ERR = 1
        YTEXT1 = "Error fatal al crear el hilo!"
    CASE ERR = 2
        YTEXT1 = "No se puede encontrar JVM.dll!"
    CASE ERR = 3
        YTEXT1 = "Clase ": className :" no existe!"
    CASE ERR = 4
        YTEXT1 = "Error de conversion UNICODE!"
    CASE ERR = 5
        YTEXT1 = "Metodo ": methodName : " no existe!"
    CASE ERR = 6
        YTEXT1 = "No se puede encontrar objeto Constructor!"
    CASE ERR = 7
        YTEXT1 = "No se puede instanciar objecto!"
    CASE @TRUE
        YTEXT1 = "Error desconocido!"
    END CASE
    .OFAC.RET = ''

    RETURN

FORM.SQLPARAM:
*-----------------------------------------------------------
*    Form the Customer name as selection criteria for SQL.
*-----------------------------------------------------------
    Y.PARAM.VAL.NO = DCOUNT(Y.PARAM1," ")
    IF Y.PARAM.VAL.NO NE "1" THEN
        Y.PARAM.NEW = ""
        Y.CNT = 1
        LOOP
        WHILE Y.CNT LE Y.PARAM.VAL.NO
            Y.PARAM.NEW := "%":FIELD(Y.PARAM1," ",Y.CNT)
            Y.CNT++
        REPEAT
        Y.PARAM1 = Y.PARAM.NEW
        IF Y.PARAM1 NE "" THEN
            Y.PARAM1 := "%"
        END
    END     ELSE
        Y.PARAM1 = "%":Y.PARAM1:"%"
    END

    RETURN

PARAM.CHECK1:
*----------------------------------------------------------
* Given Names and Family name are checked for their value
*----------------------------------------------------------
    IF PARAM9 EQ '' AND PARAM10 EQ '' THEN
        AF = EB.CUS.GIVEN.NAMES
        ETEXT = 'EB-MANDATORY.INP.MISSING'
        CALL STORE.END.ERROR
        AF = EB.CUS.FAMILY.NAME
        ETEXT = 'EB-MANDATORY.INP.MISSING'
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
    IF PARAM9 EQ '' THEN
        AF = EB.CUS.GIVEN.NAMES
        ETEXT = 'EB-MANDATORY.INP.MISSING'
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
    IF PARAM10 EQ '' THEN
        AF = EB.CUS.FAMILY.NAME
        ETEXT = 'EB-MANDATORY.INP.MISSING'
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END

    RETURN

PARAM.CHECK2:
*-----------------------------------------------------------
* Name1 , Name2 and Text are checked for their value
*-----------------------------------------------------------
    IF PARAM10 EQ '' THEN
        AF = EB.CUS.TEXT
        ETEXT = 'EB-MANDATORY.INP.MISSING'
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END

    RETURN

PGM.END:

END
