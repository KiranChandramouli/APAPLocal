* @ValidationCode : MjoxMTA2NDE0MzM4OkNwMTI1MjoxNjg0ODQyMTAwMzM2OklUU1M6LTE6LTE6MjUyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 252
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FIND.OFAC

****************************************************************
*-------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RAJA SAKTHIVEL K P
* Program Name : REDO.FIND.OFAC
*-------------------------------------------------------------------------
* Modification History :
* Date Who Reference Description
* 28-MAR-2011 RMONDRAGON ODR-2009-07-0068 UPDATE TO FOR THE CUSTOMER
* NAME AS SELECTION CRITERIA
* IN A PROPER WAY TO BE FOUND IN
* OFAC SQL SERVER DATABASE
* 03-JUN-2011 GCORDOVA PACS00036104 INTEGRATION WITH C.22 LOG AND
* FAILURE MANAGEMENT UPDATED
* UPDATE TO PROCESS ALL NAME FIELDS
* IF CUSTOMER IS MORAL OR LEGAL
* PERSON
* 30-AUG-2011 RMONDRAGON ODR-2009-07-0068 FIX FOR PACS00108777
* 09-SEP-2011 IROMANVERA ODR-2009-07-0068 OFAC Case Review - PACS00087206 - Update
* 04-OCT-2011 RMONDRAGON ODR-2009-07-0068 Update for PACS001039776
*-------------------------------------------------------------------------
* Description :This subroutine is performed in CUSTOMER,LISTAS version as input
* subroutine when a new customer is created or when
* an existing customer is modified

* The functionality is to validate if customer is not in OFAC list through
* CALLJ function to execute a java program and a query in the OFAC
* database to validate this condition

* According with the result of the query, the subroutine displays an
* error message if an error occurs on database


* Linked with: Version CUSTOMER,LISTAS as input routine
* In parameter : None
* out parameter : None

** 06-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM, = to EQ
** 06-04-2023 Skanda R22 Manual Conversion added APAP.TAm,*R22 interface Unit testing changes
*----------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.OFAC.DBCM
    $INSERT I_F.REDO.INTERFACE.ACT
    $INSERT I_F.REDO.INTERFACE.ACT.DETAILS
    $INSERT JBC.h
    $USING APAP.REDOCHNLS


    GOSUB INITIALISE
    GOSUB OPENING
    GOSUB READING
    GOSUB CHECKING.LOCAL
    GOSUB USING.CALLJ

RETURN
*-----------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------
*    KEY1="123456"  SJ commented for test
    KEY1="12345678" ;*R22 interface Unit testing changes
******************************************
* OFAC Case Review - PACS00087206 - Update
* OVERRIDE MESSAGES
* CURR.NO = 0
* CALL STORE.OVERRIDE(CURR.NO)
************************************
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

    CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',REF.POS)
    Y.PARAM = R.NEW(EB.CUS.LOCAL.REF)<1,REF.POS>
RETURN

*------------------------------------------------------------------
OPENING:
*------------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

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

*------------------------------------------------------------------
READING:
*------------------------------------------------------------------
*Description : The encrypted values are read from the "SYSTEM" record and they are decrypted here
* The decrypted values are then assigned to the param values to be passed in CALLJ function
*------------------------------------------------------------------

*CALL F.READ(FN.REDO.OFAC.DBCM,REDO.OFAC.DBCM.ID,R.REDO.OFAC.DBCM,F.REDO.OFAC.DBCM,ERR.REDO.OFAC.DBCM)
* Change F.READ for CACHE.READ, suggested by Lakshmanan Venkatachalam
    CALL CACHE.READ(FN.REDO.OFAC.DBCM,REDO.OFAC.DBCM.ID,R.REDO.OFAC.DBCM,ERR.REDO.OFAC.DBCM)
* 20170215 /S
*    IPADD.DESC = DECRYPT(R.REDO.OFAC.DBCM<REDO.DBCM.IP.ADD>,KEY1,JBASE_CRYPT_DES)
*    PORT.DESC = DECRYPT(R.REDO.OFAC.DBCM<REDO.DBCM.PORT>,KEY1,JBASE_CRYPT_DES)
*    DBNAME.DESC = DECRYPT(R.REDO.OFAC.DBCM<REDO.DBCM.DB.NAME>,KEY1,JBASE_CRYPT_DES)
*    TBNAME.DESC = DECRYPT(R.REDO.OFAC.DBCM<REDO.DBCM.TB.NAME>,KEY1,JBASE_CRYPT_DES)
    
    USER.DESC = DECRYPT(R.REDO.OFAC.DBCM<REDO.DBCM.DB.USER>,KEY1,JBASE_CRYPT_DES_BASE64)
    PWD.DESC = DECRYPT(R.REDO.OFAC.DBCM<REDO.DBCM.DB.PWD>,KEY1,JBASE_CRYPT_DES_BASE64)

    IPADD.DESC = R.REDO.OFAC.DBCM<REDO.DBCM.IP.ADD>
    PORT.DESC = R.REDO.OFAC.DBCM<REDO.DBCM.PORT>
    DBNAME.DESC = R.REDO.OFAC.DBCM<REDO.DBCM.DB.NAME>
    TBNAME.DESC = R.REDO.OFAC.DBCM<REDO.DBCM.TB.NAME>
*USER.DESC = R.REDO.OFAC.DBCM<REDO.DBCM.DB.USER>
*PWD.DESC = R.REDO.OFAC.DBCM<REDO.DBCM.DB.PWD>
* 20170215 /E
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
    CHANGE @VM TO '/' IN PARAM8

    MSG1 = R.REDO.OFAC.DBCM<REDO.DBCM.MSG.IF.EX.CU>
    MSG2 = R.REDO.OFAC.DBCM<REDO.DBCM.MSG.IF.DB.ER>
    PARAM11 = R.REDO.OFAC.DBCM<REDO.DBCM.STORE.PROC.NAME>
    PARAM12 = R.REDO.OFAC.DBCM<REDO.DBCM.EMAIL.FROM.ADD>

    SEL.CMD='SELECT ':FN.REDO.INTERFACE.ACT
    SEL.CMD:=' WITH ID.INTERFACE = ':INT.CODE

    CALL EB.READLIST(SEL.CMD, Y.REDO.INTERFACE.ACT.SELLIST, '', NO.REC, ER.SEL)
    INT.ID = Y.REDO.INTERFACE.ACT.SELLIST<1>

RETURN

CHECKING.LOCAL:
*-------------------------------------------------------------------------------------------
* Read the value of local table L.CU.TIPO.CL from the current record in CUSTOMER application
* and based on its value,we assign the names for PARAM9 and PARAM10

*-------------------------------------------------------------------------------------------
    BEGIN CASE
        CASE R.NEW(EB.CUS.LOCAL.REF)<1,REF.POS> EQ "PERSONA FISICA" OR R.NEW(EB.CUS.LOCAL.REF)<1,REF.POS> EQ "CLIENTE MENOR"
            PARAM9 = R.NEW(EB.CUS.GIVEN.NAMES)

            Y.PARAM1 = PARAM9
            GOSUB FORM.SQLPARAM
            PARAM9 = Y.PARAM1

            PARAM10 = R.NEW(EB.CUS.FAMILY.NAME)
            Y.PARAM1 = PARAM10
            GOSUB FORM.SQLPARAM
            PARAM10 = Y.PARAM1

            Y.TEMP = PARAM9
            PARAM9 = PARAM10
            PARAM10 = Y.TEMP      ;*:"%"

            PF='Y'
            GOSUB PARAM.CHECK1

        CASE R.NEW(EB.CUS.LOCAL.REF)<1,REF.POS> EQ "PERSONA JURIDICA"
* PARAM9 = R.NEW(EB.CUS.NAME.1):" ":R.NEW(EB.CUS.NAME.2)
            IF MARK.NAME.2 EQ "N" THEN
                PARAM9 = R.NEW(EB.CUS.NAME.1)
                MARK.NAME.2 = "Y"
            END ELSE
                PARAM9 = R.NEW(EB.CUS.NAME.2)
                MARK.NAME.2 = ""
            END

            Y.PARAM1 = PARAM9
            GOSUB FORM.SQLPARAM
            PARAM9 = Y.PARAM1     ;*:"%"

            PARAM10 = R.NEW(EB.CUS.TEXT)
            Y.PARAM1 = PARAM10
            GOSUB FORM.SQLPARAM
            PARAM10 = Y.PARAM1    ;*:"%"

            PF='N'
            GOSUB PARAM.CHECK2
    END CASE

    ALLPARAM = PARAM1:",":PARAM2:",":PARAM3:",":PARAM4:",":PARAM5:",":PARAM6:",":PARAM7:",":PARAM8:",":PARAM9:",":PARAM10:",":PF:",":MSG2:",":PARAM11:",":PARAM12

RETURN

USING.CALLJ:
*------------------------------------------------------------------------------
* Initialize the variables for using CALLJ function
*------------------------------------------------------------------------------
    className = "com.temenos.redo.ofac"
    methodName = "searchCusOfac"

    CALLJ className,methodName, ALLPARAM SETTING ret ON ERROR
        GOSUB ERROR.HANDLER
    END

*------------------------------------------------------------------------------
* Message handling block

* We are displaying the message based on the return value from CALLJ function

*------------------------------------------------------------------------------
    
    IF ret NE 0 THEN
        BEGIN CASE
            CASE ret EQ 1 ;* R22 Auto conversion
*         CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,MSG1,REC.CON,EX.USER,EX.PC)
                APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,MSG1,REC.CON,EX.USER,EX.PC)
                Y.MSG = MSG1
* Override Mesages OFAC Case Review - PACS00087206 - Update
* Update for PACS00139776
                TEXT = "APAP.REDO.OFAC.MSG":@FM:MSG1
                CURR.NO = DCOUNT(R.NEW(EB.CUS.OVERRIDE),@VM) + 1
                CALL STORE.OVERRIDE(CURR.NO)
                RETURN

            CASE ret EQ 2 ;* R22 Auto conversion
*  APAP.TAM.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,MSG2,REC.CON,EX.USER,EX.PC) ;* R22 Manual conversion
                APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,MSG2,REC.CON,EX.USER,EX.PC)
                Y.MSG = MSG2
* Override Mesages OFAC Case Review - PACS00087206 - Update
* Update for PACS00139776
                TEXT = "APAP.REDO.OFAC.MSG":@FM:MSG2
                CURR.NO = DCOUNT(R.NEW(EB.CUS.OVERRIDE),@VM) + 1
                CALL STORE.OVERRIDE(CURR.NO)
                RETURN

            CASE ret EQ 3 ;* R22 Auto conversion
*APAP.TAM.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,MSG2,REC.CON,EX.USER,EX.PC) ;* R22 Manual conversion
                APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,MSG2,REC.CON,EX.USER,EX.PC)
                Y.MSG = MSG2
* Override Mesages OFAC Case Review - PACS00087206 - Update
* Update for PACS00139776
                TEXT = "APAP.REDO.OFAC.MSG":@FM:MSG2
                CURR.NO = DCOUNT(R.NEW(EB.CUS.OVERRIDE),@VM) + 1
                CALL STORE.OVERRIDE(CURR.NO)
                RETURN
        END CASE

    END ELSE
        IF MARK.NAME.2 EQ "Y" AND PF EQ "N" THEN
            GOSUB CHECKING.LOCAL
        END ELSE
            RETURN
        END
    END

RETURN

ERROR.HANDLER:
*------------------------------------------------------------------------------
* Error handling functions
* The error value if results from CALLJ function are handled using this block

*------------------------------------------------------------------------------
    ERR = SYSTEM(0)
    BEGIN CASE
        CASE ERR EQ 1
            YTEXT1 = "Error fatal al crear el hilo!"
        CASE ERR EQ 2
            YTEXT1 = "No se puede encontrar JVM.dll!"
        CASE ERR EQ 3
            YTEXT1 = "Clase ": className :" no existe!"
        CASE ERR EQ 4
            YTEXT1 = "Error de conversion UNICODE!"
        CASE ERR EQ 5
            YTEXT1 = "Metodo ": methodName : " no existe!"
        CASE ERR EQ 6
            YTEXT1 = "No se puede encontrar objeto Constructor!"
        CASE ERR EQ 7
            YTEXT1 = "No se puede instanciar objecto!"
        CASE @TRUE
            YTEXT1 = "Error desconocido!"
    END CASE

* Y.MSG = YTEXT1
* GOSUB LOG.REG
*APAP.TAM.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,YTEXT1,REC.CON,EX.USER,EX.PC) ;* R22 Manual conversion
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,YTEXT1,REC.CON,EX.USER,EX.PC)
RETURN

PARAM.CHECK1:
*----------------------------------------------------------
* Given Names and Family name are checked for their value

*----------------------------------------------------------
    BEGIN CASE
        CASE PARAM9 EQ '' AND PARAM10 EQ ''
            AF = EB.CUS.GIVEN.NAMES
            ETEXT = 'EB-MANDATORY.INP.MISSING':@FM:Y.PARAM
            CALL STORE.END.ERROR
            AF = EB.CUS.FAMILY.NAME
            ETEXT = 'EB-MANDATORY.INP.MISSING':@FM:Y.PARAM
            CALL STORE.END.ERROR
            GOSUB PGM.END

        CASE PARAM9 EQ ''
            AF = EB.CUS.GIVEN.NAMES
            ETEXT = 'EB-MANDATORY.INP.MISSING':@FM:Y.PARAM
            CALL STORE.END.ERROR
            GOSUB PGM.END

        CASE PARAM10 EQ ''
            AF = EB.CUS.FAMILY.NAME
            ETEXT = 'EB-MANDATORY.INP.MISSING':@FM:Y.PARAM
            CALL STORE.END.ERROR
            GOSUB PGM.END

    END CASE
RETURN

PARAM.CHECK2:
*-----------------------------------------------------------
* Name1 , Name2 and Text are checked for their value

*-----------------------------------------------------------

* IF R.NEW(EB.CUS.NAME.2) EQ '' AND PARAM10 EQ '' THEN
* AF = EB.CUS.NAME.2
* ETEXT = 'EB-MANDATORY.INP.MISSING':FM:Y.PARAM
* CALL STORE.END.ERROR
* AF = EB.CUS.TEXT
* ETEXT = 'EB-MANDATORY.INP.MISSING':FM:Y.PARAM
* CALL STORE.END.ERROR
* GOSUB PGM.END
* END
*
* IF R.NEW(EB.CUS.NAME.2) EQ '' THEN
* AF = EB.CUS.NAME.2
* ETEXT = 'EB-MANDATORY.INP.MISSING':FM:Y.PARAM
* CALL STORE.END.ERROR
* GOSUB PGM.END
* END
    IF PARAM10 EQ '' THEN
        AF = EB.CUS.TEXT
        ETEXT = 'EB-MANDATORY.INP.MISSING':@FM:Y.PARAM
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END

RETURN

FORM.SQLPARAM:
*-----------------------------------------------------------
* Form the Customer name as selection criteria for SQL
*-----------------------------------------------------------
    Y.PARAM.VAL.NO = DCOUNT(Y.PARAM1," ")
    IF Y.PARAM.VAL.NO NE "1" THEN
        Y.PARAM.NEW = ""
        Y.CNT = 1
        LOOP
        WHILE Y.CNT LE Y.PARAM.VAL.NO
            Y.PARAM.NEW := "%":FIELD(Y.PARAM1," ",Y.CNT)
            Y.CNT += 1 ;* R22 Auto conversion
        REPEAT
        Y.PARAM1 = Y.PARAM.NEW
        IF Y.PARAM1 NE "" THEN
            Y.PARAM1 := "%"
        END
    END ELSE
        Y.PARAM1 = "%":Y.PARAM1:"%"
    END

RETURN

LOG.REG:
*------------------------------------------------------------------
* REGISTRY LO IN C.22
*------------------------------------------------------------------
    SEL.CMD='SELECT ':FN.REDO.INTERFACE.ACT.DETAILS
    SEL.CMD:=' WITH ID.INTERFACE.ACT = ':INT.ID
    SEL.CMD:=' AND @ID LIKE ':INT.CODE:".":Y.YEAR:Y.MONTH:Y.DATE:".":INT.TYPE:"..."

    CALL EB.READLIST(SEL.CMD, Y.REDO.INTERFACE.ACT.DETAILS.SELLIST, '', NO.REC, ER.SEL)

    Y.CONT = STR('0', 6-LEN(NO.REC+1)):NO.REC+1

    ID.DET = INT.CODE:".":Y.YEAR:Y.MONTH:Y.DATE:".":INT.TYPE:".":Y.CONT
    INT.CODE.REC<REDO.INT.ACT.DET.ID.INTERFACE.ACT>=INT.ID
    INT.CODE.REC<REDO.INT.ACT.DET.ID.MONITOR.TYPE>=MON.TP
    INT.CODE.REC<REDO.INT.ACT.DET.RECORD.ID>=ID.PROC
    INT.CODE.REC<REDO.INT.ACT.DET.DESCRIPTION>=Y.MSG
    INT.CODE.REC<REDO.INT.ACT.DET.TIME>=Y.YEAR:Y.MONTH:Y.DATE:" ":Y.HOUR:":":Y.MINUTE:":":Y.SECOND

    LOCK.FLUSH=""
    CALL LOG.WRITE(FN.REDO.INTERFACE.ACT.DETAILS,ID.DET,INT.CODE.REC,LOCK.FLUSH)

RETURN

PGM.END:

END
