* @ValidationCode : MjoxNzk2MDU1NTUzOkNwMTI1MjoxNjg2Njc0MjQzMzY5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:07:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*---------------------------------------------------------------------------------------
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE              WHO                    REFERENCE                   DESCRIPTION
*13/06/2023      Santosh          R22 MANUAL CODE CONVERSION       Remove AL from LOCATE
*---------------------------------------------------------------------------------------
PROGRAM ADM.BLOQUEA.USUARIO
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
   $USING EB.TransactionControl

    GOSUB INICIALIZACION
    GOSUB LISTA.SEGURIDAD
    GOSUB LISTA.ADMINISTRACION
    GOSUB LISTA.PRODUCCION
    GOSUB LISTA.BLANCA
    GOSUB PROCESAMIENTO
RETURN

*==================================================
*INICIALIZACION
*==================================================
INICIALIZACION:
*DEBUG
    FN.USR = 'F.USER'
    FV.USR = ''
    CALL OPF(FN.USR, FV.USR)

    SEL.CMD = ''
    SEL.LIST = ''
    NO.OF.RECS = ''
    SEL.ERR = ''

    Y.LST.BLANCA = ''
*DEBUG
    Y.DATE = OCONV(DATE(), "DY4") :  FMT(OCONV(DATE(), "DM"), 'R%2') : FMT(OCONV(DATE(), "DD"), 'R%2')
    Y.TIME = TIME()

    V.COUNT = -1
*    V.COUNT = 1

    EXECUTE 'clear'
RETURN

*==================================================
*PROCESAMIENTO
*==================================================
PROCESAMIENTO:
*DEBUG
    SEL.CMD = "SELECT " : FN.USR
*SEL.CMD := " WITH @ID NE " : Y.OPERATOR

    CALL EB.READLIST(SEL.CMD, SEL.LIST, '', NO.OF.RECS, SELL.ERR)

    LOOP
        REMOVE Y.REC.ID FROM SEL.LIST SETTING FI.POS
    WHILE Y.REC.ID DO
        R.USR = ""; USR.ERROR = ""
        CALL CACHE.READ(FN.USR, Y.REC.ID, R.USR, USR.ERROR)
        Y.END.DATE.PROFILE = R.USR<EB.USE.END.DATE.PROFILE>
        V.USER.NAME = R.USR<EB.USE.USER.NAME>

        EXECUTE 'clear'

        V.COUNT += 1

        IF V.COUNT EQ 0 THEN
            PRINT @(10,1) : "PROCESO BLOQUEO USUARIOS EN CURSO "

        END

        IF V.COUNT EQ 1 THEN
            PRINT @(10,1) : "PROCESO BLOQUEO USUARIOS EN CURSO >>>"

        END

        IF V.COUNT EQ 2 THEN
            PRINT @(10,1) : "PROCESO BLOQUEO USUARIOS EN CURSO >>>>   >>>>"
        END

        IF V.COUNT EQ 3 THEN
            PRINT @(10,1) : "PROCESO BLOQUEO USUARIOS EN CURSO >>>>>   >>>>>   >>>>>"
            V.COUNT = -1
        END

        PRINT @(10,4) : "============================================================"
*        PRINT @(10,5) : V.USER.NAME
        PRINT @(10,5) : "USER ID          : " : Y.REC.ID
        PRINT @(10,6) : "NOMBRE           : " : V.USER.NAME
        PRINT @(10,7) : "END DATE PROFILE : " : Y.END.DATE.PROFILE
        PRINT @(10,8) : "============================================================"

        IF Y.END.DATE.PROFILE GE Y.DATE THEN
*           LOCATE Y.REC.ID IN Y.LST.BLANCA BY AL SETTING Y.POS THEN
            LOCATE Y.REC.ID IN Y.LST.BLANCA SETTING Y.POS THEN   ;*R22 MANUAL CODE CONVERSION
                PRINT @(10,10) : "USUARIO NO BLOQUEABLE: " : Y.POS : SPACE(20)
*SLEEP 1
            END ELSE
                PRINT @(10,10) : "USUARIO BLOQUEABLE" : SPACE(26)
*SLEEP 0.5
*IF Y.REC.ID EQ "PMM.A12362A" THEN
*                   DEBUG
                PRINT @(10,9) : "Y.REC.ID:          " : Y.REC.ID
                R.USR<EB.USE.END.DATE.PROFILE> = "20160101"
                CALL F.WRITE(FN.USR, Y.REC.ID, R.USR)
*                CALL JOURNAL.UPDATE('')
EB.TransactionControl.JournalUpdate('');* R22 UTILITY AUTO CONVERSION
*                    INPUT XX
*END
            END
        END
        ELSE
            PRINT @(10,10) : "ESTA BLOQUEADO DESDE EL: " : Y.END.DATE.PROFILE
*SLEEP 0.5
        END

    REPEAT

    EXECUTE 'clear'

*    PRINT @(10,11) : "***PRESIONE CUALQUIER TECLA PARA FINALIZAR***"
    PRINT @(10,9)  : "==============================================="
    PRINT @(10,10) : "***** PROCESO BLOQUEO USUARIOS FINALIZADO *****"
    PRINT @(10,11) : "==============================================="

*    INPUT XX
RETURN

*==================================================
*SEGURIDAD DE LA INFORMACION
*==================================================
LISTA.SEGURIDAD:
*DEBUG
    Y.LST.BLANCA = ''
    Y.LST.BLANCA := 'A.12383' : @FM
    Y.LST.BLANCA := 'A.12479' : @FM
    Y.LST.BLANCA := 'A.11587' : @FM
    Y.LST.BLANCA := 'A.12269' : @FM
    Y.LST.BLANCA := 'A.12794' : @FM
    Y.LST.BLANCA := 'A.12732' : @FM
    Y.LST.BLANCA := 'A.12644' : @FM
    Y.LST.BLANCA := 'A.11349' : @FM
    Y.LST.BLANCA := 'A.11463' : @FM
    Y.LST.BLANCA := 'A.12058' : @FM
RETURN

*==================================================
*ADMINISTRACION DE AMBIENTES
*==================================================
LISTA.ADMINISTRACION:
*DEBUG
    Y.LST.BLANCA := 'A.13047' : @FM
    Y.LST.BLANCA := 'A.10107' : @FM
    Y.LST.BLANCA := 'A.13051' : @FM
    Y.LST.BLANCA := 'A.13963' : @FM
    Y.LST.BLANCA := 'A.13979' : @FM
    Y.LST.BLANCA := 'A.13984' : @FM
    Y.LST.BLANCA := 'C.01150' : @FM
    Y.LST.BLANCA := 'C.01210' : @FM
RETURN

*==================================================
*OPERADORES DE PRODUCCION
*==================================================
LISTA.PRODUCCION:
*DEBUG
    Y.LST.BLANCA := 'A.14227' : @FM
    Y.LST.BLANCA := 'A.13515' : @FM
    Y.LST.BLANCA := 'A.13035' : @FM
    Y.LST.BLANCA := 'A.13977' : @FM
    Y.LST.BLANCA := 'A.13315' : @FM
    Y.LST.BLANCA := 'A.13951' : @FM
    Y.LST.BLANCA := 'A.13978' : @FM
RETURN

*==================================================
*LISTA BLANCA
*==================================================
LISTA.BLANCA:
*DEBUG
    EXECUTE "GET.LIST ADM.BLOQUEA.LIST"
    READLIST ID.LIST ELSE ID.LIST = ''
    LOOP
        REMOVE Y.ID FROM ID.LIST SETTING Y.STATUS
    WHILE  Y.ID:Y.STATUS
        Y.LST.BLANCA := Y.ID : @FM
    REPEAT

*DEBUG

*ORDENA LOS DIFERENTES USUARIOS
    Y.LST.BLANCA = SORT(Y.LST.BLANCA)
    SLEEP 1
    EXECUTE 'clear'
RETURN
END
