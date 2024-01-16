* @ValidationCode : MjoxMDQ5NDQ1NzMyOlVURi04OjE2OTAxNjc1NTAwOTM6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:10
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-90</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.PRE.PEND.ACT(Y.ACT.ID)
*-----------------------------------------------------------------------------
* Developed By            : APAP, Requerimiento Préstamos y Tesororia
*
* Developed On            : 17-06-2019
*
* Development Reference   : GDC-471
*
* Development Description : Buscar las actividades pendiente de autorizar al PRE-COB y los FT pendientes de autorizar
*                           relacionados a una activada filtrando por la fecha del dia, genera un reporte un reporte de
*                           las activides y realiza un reverso de las misma.
* Attached To             : BATCH>BNK/LAPAP.PRE.PEND.ACT
*
* Attached As             : Multithreaded Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* id activity #1 : Y.ACT.ID
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     No Changes
* 14-07-2023    Narmadha V             R22 Manual Conversion   BP is removed in insert file
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON ;*R22 Manual Conversion - START
    $INSERT  I_EQUATE
    $INSERT  I_BATCH.FILES
    $INSERT  I_TSA.COMMON
    $INSERT  I_F.DATES
    $INSERT  I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT  I_F.USER
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.REDO.H.REPORTS.PARAM
    $INSERT  I_F.ST.L.APAP.AAA.PENDIENTENAU
    $INSERT  I_F.AA.ARRANGEMENT
    $INSERT  I_LAPAP.PRE.PEND.ACT.COMMON ;*R22 Manual Conversion - END

    GOSUB MAIN.PROCEDURE

RETURN

MAIN.PROCEDURE:
    Y.ID.ACTIVIDA = Y.ACT.ID
    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "SELECT.INAU"
            GOSUB READ.AAAINAU

        CASE CONTROL.LIST<1,1> EQ "SELECT.LIVE"
            GOSUB READ.AAA.LIVE
    END CASE
    GOSUB WRITE.RECORD.REPORT
RETURN

READ.AAAINAU:
    R.ARRANGEMENT.ACTIVITY$NAU = ""; ERRR.AAA = "" ; Y.GRUPO = ""
    CALL F.READ(FN.ARRANGEMENT.ACTIVITY$NAU,Y.ID.ACTIVIDA, R.ARRANGEMENT.ACTIVITY$NAU, F.ARRANGEMENT.ACTIVITY$NAU , ERRR.AAA )
    INPU.USER = R.ARRANGEMENT.ACTIVITY$NAU<AA.ARR.ACT.INPUTTER>
    INPU.USER =  FIELD(INPU.USER, "_",2)
    GOSUB READ.USUARIO
    Y.CO.CODE = R.ARRANGEMENT.ACTIVITY$NAU<AA.ARR.ACT.CO.CODE>
    Y.FECHA = R.ARRANGEMENT.ACTIVITY$NAU<AA.ARR.ACT.EFFECTIVE.DATE>
    Y.ARRANGEMENT = R.ARRANGEMENT.ACTIVITY$NAU<AA.ARR.ACT.ARRANGEMENT>
    Y.STATUS.ACVITIDA = R.ARRANGEMENT.ACTIVITY$NAU<AA.ARR.ACT.RECORD.STATUS>
    GOSUB READ.ARRANGEMENT
    Y.ACTIVIDA =  R.ARRANGEMENT.ACTIVITY$NAU<AA.ARR.ACT.ACTIVITY>
    Y.TXN.SYSTEM.ID = R.ARRANGEMENT.ACTIVITY$NAU<AA.ARR.ACT.TXN.SYSTEM.ID>
    Y.TXN.CONTRACT.ID = R.ARRANGEMENT.ACTIVITY$NAU<AA.ARR.ACT.TXN.CONTRACT.ID>
    IF Y.TXN.SYSTEM.ID EQ "FT" THEN
        GOSUB READ.FT.INAU
        IF NOT(R.FUNDS.TRANSFER$NAU) THEN
            GOSUB READ.FT.LIVE
        END
    END ELSE
        Y.GRUPO = 'A'
    END
    GOSUB DESCRIPCION.GRUPOS
RETURN
READ.FT.INAU:
    R.FUNDS.TRANSFER$NAU = ""; FT.ERROR$INAU = ""
    CALL F.READ(FN.FUNDS.TRANSFER$NAU , Y.TXN.CONTRACT.ID, R.FUNDS.TRANSFER$NAU,F.FUNDS.TRANSFER$NAU,FT.ERROR$INAU)
    IF R.FUNDS.TRANSFER$NAU THEN
        Y.GRUPO = 'B'
    END
RETURN

READ.FT.LIVE:
    R.FUNDS.TRANSFER = ""; FT.ERROR = ""
    CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.CONTRACT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FT.ERROR)
    IF R.FUNDS.TRANSFER THEN
        Y.GRUPO = 'C'
    END
RETURN

READ.USUARIO:
    R.USER = ''; ERROR.USER = '';
    CALL F.READ(FN.USER,INPU.USER, R.USER, F.USER, ERROR.USER )
    Y.NOMBRE.USUARIO = R.USER<EB.USE.USER.NAME>
RETURN


READ.AAA.LIVE:
    R.ARRANGEMENT.ACTIVITY = ""; ERR.AAA = "" ; Y.GRUPO = ""
    CALL F.READ(FN.ARRANGEMENT.ACTIVITY,Y.ID.ACTIVIDA, R.ARRANGEMENT.ACTIVITY, F.ARRANGEMENT.ACTIVITY, ERR.AAA )
    Y.TXN.SYSTEM.ID = R.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.SYSTEM.ID>
    IF Y.TXN.SYSTEM.ID NE 'FT' THEN
        RETURN
    END
    Y.TXN.CONTRACT.ID = R.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.CONTRACT.ID>
    GOSUB READ.FT.INAU
    IF R.FUNDS.TRANSFER$NAU THEN
        Y.GRUPO = 'D'
        INPU.USER = R.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.INPUTTER>
        INPU.USER =  FIELD(INPU.USER, "_",2)
        GOSUB READ.USUARIO
        Y.CO.CODE = R.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.CO.CODE>
        Y.FECHA = R.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.EFFECTIVE.DATE>
        Y.ARRANGEMENT = R.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.ARRANGEMENT>
        Y.STATUS.ACVITIDA = R.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.RECORD.STATUS>
        GOSUB READ.ARRANGEMENT
        Y.ACTIVIDA =  R.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.ACTIVITY>
        GOSUB DESCRIPCION.GRUPOS
    END
RETURN

READ.ARRANGEMENT:
    R.AA.ARRANGEMENT = ''; ERROR.ARRANGEMENT  = ''
    CALL F.READ(FN.AA.ARRANGEMENT , Y.ARRANGEMENT, R.AA.ARRANGEMENT,F.AA.ARRANGEMENT, ERROR.ARRANGEMENT )
    Y.CONTRATO = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID,1,1>
RETURN

DESCRIPCION.GRUPOS:
    BEGIN CASE
*        CASE Y.GRUPO = 'A'
        CASE Y.GRUPO EQ 'A';* R22 UTILITY AUTO CONVERSION
            Y.DESCRIPCION = "Actividad Pendiente Sin FT Asociada"
*        CASE Y.GRUPO = 'B'
        CASE Y.GRUPO EQ 'B';* R22 UTILITY AUTO CONVERSION
            Y.DESCRIPCION = "Actividad Pendiente con FT Asociada SIN AUTORIZAR"
*        CASE Y.GRUPO = 'C'
        CASE Y.GRUPO EQ 'C';* R22 UTILITY AUTO CONVERSION
            Y.DESCRIPCION = "Actividad Pendiente con FT Asociada AUTORIZADA"
*        CASE Y.GRUPO = 'D'
        CASE Y.GRUPO EQ 'D';* R22 UTILITY AUTO CONVERSION
            Y.DESCRIPCION = "Actividad AUTORIZADA con FT Asociada SIN AUTORIZAR"
        CASE 1
            Y.DESCRIPCION = ""
            Y.GRUPO = ""
    END CASE

RETURN

WRITE.RECORD.REPORT:
    R.L.APAP.AAA.PENDIENTENAU = ""
    R.L.APAP.AAA.PENDIENTENAU<ST.L.A87.L.APAP.DESCRIPCION> = Y.ID.ACTIVIDA:"|":INPU.USER:"|":Y.NOMBRE.USUARIO:"|":Y.CO.CODE:"|":Y.FECHA:"|":Y.CONTRATO:"|":Y.ACTIVIDA:"|":Y.GRUPO:"|":Y.DESCRIPCION
    R.L.APAP.AAA.PENDIENTENAU<ST.L.A87.GRUPO> = Y.GRUPO
    IF Y.GRUPO NE "" THEN
        CALL F.WRITE(FN.ST.L.APAP.AAA.PENDIENTENAU, Y.ID.ACTIVIDA, R.L.APAP.AAA.PENDIENTENAU)
    END
RETURN

END
