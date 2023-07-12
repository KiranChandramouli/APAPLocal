*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.MOD.DIRECCIONES
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.MOD.DIRECCIONES
* Date           : 2019-10-22
* Item ID        : --------
*========================================================================
* Brief description :
* -------------------
* This routine write data in F.REDO.MON.SEND.QUEUE's table from ST.LAPAP.MOD.DIRECCIONES'
* versions, in order to replicate the data in other DB
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2019-10-22     Richard HC                Initial Development
*========================================================================
* Content summary :
* =================
* Table name     : F.DATES | F.CUSTOMER | ST.LAPAP.MOD.DIRECCIONES
* Auto Increment : N/A
* Views/versions : ST.LAPAP.MOD.DIRECCIONES*
* EB record      : LAPAP.MOD.DIRECCIONES
* Routine        : LAPAP.MOD.DIRECCIONES
*========================================================================



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ST.LAPAP.MOD.DIRECCIONES

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.MDIR = "F.ST.LAPAP.MOD.DIRECCIONES"
    F.MDIR = ""
    CALL OPF(FN.MDIR,F.MDIR)

    ACTUAL.MAIL = R.NEW(ST.MDIR.EMAIL)
    ACTUAL.AREA = R.NEW(ST.MDIR.CODIGO.AREA)
    ACTUAL.PHONE = R.NEW(ST.MDIR.NUMERO.TELEFONO)
    ACTUAL.ADDR = R.NEW(ST.MDIR.CALLE):" ":R.NEW(ST.MDIR.NUMERO):" ":R.NEW(ST.MDIR.SECTOR):" ":R.NEW(ST.MDIR.CIUDAD):" ":R.NEW(ST.MDIR.PROVINCIA)

    CUSTOMER.ID = R.NEW(ST.MDIR.CLIENTE)

    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
    CALL GET.LOC.REF("CUSTOMER","L.CU.CIDENT",POSCIDENT)
    CUSTOMER.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,POSCIDENT>
    CUSTOMER.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
    CUSTOMER.EMAIL = R.CUSTOMER<EB.CUS.EMAIL.1>
    CALL GET.LOC.REF("CUSTOMER","L.CU.TEL.NO",TEL.POS)
    CUSTOMER.PHONE = R.CUSTOMER<EB.CUS.LOCAL.REF,TEL.POS>
    CALL GET.LOC.REF("CUSTOMER","L.CU.RES.SECTOR",SECTOR.POS)
    CUSTOMER.SECTOR = R.CUSTOMER<EB.CUS.LOCAL.REF,SECTOR.POS>
    CUSTOMER.ADDR = R.CUSTOMER<EB.CUS.STREET>:" ":R.CUSTOMER<EB.CUS.ADDRESS>:" ":CUSTOMER.SECTOR:" ":R.CUSTOMER<EB.CUS.COUNTRY>:" ":R.CUSTOMER<EB.CUS.TOWN.COUNTRY>

    CHANGE @SM TO @VM IN CUSTOMER.PHONE
    CHANGE @SM TO @VM IN CUSTOMER.EMAIL

*   Email Validation
    ARR.EMAIL = CUSTOMER.EMAIL
    M.VAR  = DCOUNT(ACTUAL.MAIL,@VM)
    AA = M.VAR - 1
    PREVIOUS.MAIL = ACTUAL.MAIL<1,M.VAR>
    FOR A = 1 TO M.VAR STEP 1
        FIND ACTUAL.MAIL<1,A> IN ARR.EMAIL SETTING V.FLD, V.VAL ELSE
            MDIR.MAIL<-1> = ACTUAL.MAIL<1,A>

            IF PREVIOUS.MAIL EQ ACTUAL.MAIL<1,A> THEN
                PREVIOUS.MAIL = ACTUAL.MAIL<1,AA>
            END

            MQ = DCOUNT(MDIR.MAIL,@FM)
            IF MQ GE 2 THEN
                CHANGE @FM TO "; " IN MDIR.MAIL
            END
        END
    NEXT A


*   Phone Validation
    ARR.PHONE = CUSTOMER.PHONE
    MM = DCOUNT(ACTUAL.PHONE,@VM)
    FOR B.VAR = 1 TO MM STEP 1
        FIND ACTUAL.PHONE<1,B.VAR> IN ARR.PHONE SETTING V.FLD, V.VAL ELSE
            MDIR.PHONE<-1> = ACTUAL.AREA<1,B.VAR>:ACTUAL.PHONE<1,B.VAR>
            MP =  DCOUNT(MDIR.PHONE,@FM)
            IF MP GE 2 THEN
                CHANGE @FM TO "; " IN MDIR.PHONE
            END
        END
    NEXT B.VAR


*   Address validation
    IF CUSTOMER.ADDR NE ACTUAL.ADDR THEN
        MDIR.ADDR<-1> = ACTUAL.ADDR
    END

    CHANGE "," TO " " IN MDIR.ADDR

    BEGIN CASE
        CASE MDIR.MAIL AND MDIR.PHONE AND MDIR.ADDR

            HTML = '</br><b>Teléfono~ </b>':MDIR.PHONE:'</br><b>Correo~ </b>':MDIR.MAIL:'</br><b>Dirección~ </b>':MDIR.ADDR:'</br>'
            VALUES.TO.INSERT = CUSTOMER.CIDENT:',':CUSTOMER.ID:',':CUSTOMER.NAME:',':MDIR.PHONE:',':MDIR.MAIL:',':MDIR.ADDR:',':PREVIOUS.MAIL:',':HTML:',':OPERATOR:',':R.DATES(EB.DAT.TODAY):',':TIME.STAMP[1,8]:','

        CASE MDIR.PHONE AND MDIR.ADDR

            HTML = '</br><b>Teléfono~ </b>':MDIR.PHONE:'</br><b>Dirección~ </b>':MDIR.ADDR:'</br>'
            VALUES.TO.INSERT = CUSTOMER.CIDENT:',':CUSTOMER.ID:',':CUSTOMER.NAME:',':MDIR.PHONE:',':'':',':MDIR.ADDR:',':PREVIOUS.MAIL:',':HTML:',':OPERATOR:',':R.DATES(EB.DAT.TODAY):',':TIME.STAMP[1,8]:','

        CASE MDIR.PHONE AND MDIR.MAIL

            HTML = '</br><b>Teléfono~ </b>':MDIR.PHONE:'</br><b>Correo~ </b>':MDIR.MAIL:'</br>'
            VALUES.TO.INSERT = CUSTOMER.CIDENT:',':CUSTOMER.ID:',':CUSTOMER.NAME:',':MDIR.PHONE:',':MDIR.MAIL:',':'':',':PREVIOUS.MAIL:',':HTML:',':OPERATOR:',':R.DATES(EB.DAT.TODAY):',':TIME.STAMP[1,8]:','

        CASE MDIR.ADDR AND MDIR.MAIL

            HTML = '</br><b>Correo~ </b>':MDIR.MAIL:'</br><b>Dirección~ </b>':MDIR.ADDR:'</br>'
            VALUES.TO.INSERT = CUSTOMER.CIDENT:',':CUSTOMER.ID:',':CUSTOMER.NAME:',':'':',':MDIR.MAIL:',':MDIR.ADDR:',':PREVIOUS.MAIL:',':HTML:',':OPERATOR:',':R.DATES(EB.DAT.TODAY):',':TIME.STAMP[1,8]:','

        CASE MDIR.ADDR

            HTML = '</br><b>Dirección~ </b>':MDIR.ADDR:'</br>'
            VALUES.TO.INSERT = CUSTOMER.CIDENT:',':CUSTOMER.ID:',':CUSTOMER.NAME:',':'':',':'':',':MDIR.ADDR:',':PREVIOUS.MAIL:',':HTML:',':OPERATOR:',':R.DATES(EB.DAT.TODAY):',':TIME.STAMP[1,8]:','

        CASE MDIR.MAIL

            HTML = '</br><b>Correo~ </b>':MDIR.MAIL:'</br>'
            VALUES.TO.INSERT = CUSTOMER.CIDENT:',':CUSTOMER.ID:',':CUSTOMER.NAME:',':'':',':MDIR.MAIL:',':'':',':PREVIOUS.MAIL:',':HTML:',':OPERATOR:',':R.DATES(EB.DAT.TODAY):',':TIME.STAMP[1,8]:','

        CASE MDIR.PHONE

            HTML = '</br><b>Teléfono~ </b>':MDIR.PHONE:'</br>'
            VALUES.TO.INSERT = CUSTOMER.CIDENT:',':CUSTOMER.ID:',':CUSTOMER.NAME:',':MDIR.PHONE:',':'':',':'':',':PREVIOUS.MAIL:',':HTML:',':OPERATOR:',':R.DATES(EB.DAT.TODAY):',':TIME.STAMP[1,8]:','

    END CASE

    CHANGE ":" TO "" IN VALUES.TO.INSERT
    CHANGE "~" TO ":" IN VALUES.TO.INSERT

    IF VALUES.TO.INSERT NE '' THEN

        ARR = ''
        ARR<-1> = CUSTOMER.ID:"-CUSTOMER.DEMOGRAPHYC.CHANGES"
        ARR<-1> = "IDENTIFICACION,CODIGO_CLIENTE,NOMBRE,TELEFONO_MODIFICADO,CORREO_MODIFICADO,DIRECCION_MODIFICADA,CORREO_ACTUAL,HTML,INPUTADOR,FECHA,HORA,"
        ARR<-1> = "C,C,C,C,C,C,C,C,C,C,C,"
        ARR<-1> = VALUES.TO.INSERT
        ARR<-1> = "CUSTOMER_DEMOGRAPHYC_CHANGES"
        CALL LAPAP.BUILD.MONITOR.FROM.VERSION(ARR)

    END   ELSE

        AF = ST.MDIR.CLIENTE
        ETEXT  = 'NO REALIZO NINGUN CAMBIO AL CLIENTE.'
        CALL STORE.END.ERROR

        RETURN

    END


END
