* @ValidationCode : MjotNDEwNjgyNDk0OlVURi04OjE2ODkzMjY2MzM4ODc6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 14 Jul 2023 14:53:53
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>8</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.OFS.TASA.REPRECIO

* --------------------------------------------------------
* Version routine, attached to versions: ST.LAPAP.REPRECIO.TASA,MICRO and ST.LAPAP.REPRECIO.TASA.MARGEN,MICRO
* Created by Oliver Fermin
* Date: 25/02/2021
* Launch OFS Message to change Fixed Rate and Margin Rate > AA and AZ Products. Aditional see the NOFILE.LAPAP.ENQ.REPRECIO enquiry.
* --------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     No Changes
* 14-07-2023    Narmadha V             R22 Manual Conversion   BP is removed in insert file
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON ;*R22 Manual Conversion -START
    $INSERT  I_EQUATE
    $INSERT  I_GTS.COMMON
    $INSERT  I_F.DATES
    $INSERT  I_F.COMPANY
    $INSERT  I_AA.LOCAL.COMMON
    $INSERT  I_F.AA.ARRANGEMENT
    $INSERT  I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.LAPAP.REPRECIO.TASA
    $INSERT  I_F.LAPAP.REPRECIO.TASA.MARGEN ;*R22 Manual Conversion -END

*EXECUTE "COMO ON LAPAP.OFS.TASA.REPRECIO"
    GOSUB INIT
    GOSUB PROCESS
*EXECUTE "COMO OFF LAPAP.OFS.TASA.REPRECIO"

RETURN

INIT:
****

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

RETURN


PROCESS:
********

    FT.VERSION = APPLICATION:PGM.VERSION;

    IF FT.VERSION EQ "ST.LAPAP.REPRECIO.TASA,MICRO" THEN
*Cambio de tasa
        Y.NUMBER.PRODUCT = R.NEW(ST.L.A6.NUMERO.PRODUCTO);
        Y.TASA           = R.NEW(ST.L.A6.TASA);
*CRT "IF Y.NUMBER.PRODUCT: ":Y.NUMBER.PRODUCT:", Y.TASA:":Y.TASA
        GOSUB OFS.CAMBIO.TASA

    END ELSE IF FT.VERSION EQ "ST.LAPAP.REPRECIO.TASA.MARGEN,MICRO" THEN
*Cambio de tasa margen
        Y.NUMBER.PRODUCT = R.NEW(ST.L.A6.NUMERO.PRODUCTO);
        Y.TASA           = R.NEW(ST.L.A6.TASA.MARGEN);
*CRT "ELSE IF Y.NUMBER.PRODUCT: ":Y.NUMBER.PRODUCT:", Y.TASA:":Y.TASA
        GOSUB OFS.CAMBIO.TASA.MARGEN
    END

RETURN



OFS.CAMBIO.TASA:
*******************

    Y.OFS.QUEUE = "AA.ARRANGEMENT.ACTIVITY,AA.PRESTAMO/I/PROCESS///,//":ID.COMPANY:",,ARRANGEMENT:1:1=":Y.NUMBER.PRODUCT:",ACTIVITY:1:1=LENDING-CHANGE-PRINCIPALINT,PROPERTY:1:1=PRINCIPALINT,FIELD.NAME:1:1=FIXED.RATE,FIELD.VALUE:1:1=":Y.TASA:",";
    GOSUB EJECUTAR.OFS.POST.MESSAGE

    Y.OFS.QUEUE = "AA.ARRANGEMENT.ACTIVITY,AA.PRESTAMO/I/PROCESS///,//":ID.COMPANY:",,ARRANGEMENT:1:1=":Y.NUMBER.PRODUCT:",ACTIVITY:1:1=LENDING-CHANGE-PENALTINT,PROPERTY:1:1=PENALTINT,FIELD.NAME:1:1=FIXED.RATE,FIELD.VALUE:1:1=":Y.TASA:",";
    GOSUB EJECUTAR.OFS.POST.MESSAGE

RETURN

OFS.CAMBIO.TASA.MARGEN:
***********************

    Y.OFS.QUEUE = "AA.ARRANGEMENT.ACTIVITY,AA.PRESTAMO/I/PROCESS///,//":ID.COMPANY:",,ARRANGEMENT:1:1=":Y.NUMBER.PRODUCT:",ACTIVITY:1:1=LENDING-CHANGE-PRINCIPALINT,PROPERTY:1:1=PRINCIPALINT,FIELD.NAME:1:1=MARGIN.RATE,FIELD.NAME:1:2=MARGIN.TYPE,FIELD.VALUE:1:1=":Y.TASA:",FIELD.VALUE:1:2=SINGLE";
    GOSUB EJECUTAR.OFS.POST.MESSAGE

    Y.OFS.QUEUE = "AA.ARRANGEMENT.ACTIVITY,AA.PRESTAMO/I/PROCESS///,//":ID.COMPANY:",,ARRANGEMENT:1:1=":Y.NUMBER.PRODUCT:",ACTIVITY:1:1=LENDING-CHANGE-PENALTINT,PROPERTY:1:1=PENALTINT,FIELD.NAME:1:1=MARGIN.RATE,FIELD.NAME:1:2=MARGIN.TYPE,FIELD.VALUE:1:1=":Y.TASA:",FIELD.VALUE:1:2=SINGLE";
    GOSUB EJECUTAR.OFS.POST.MESSAGE

RETURN


EJECUTAR.OFS.POST.MESSAGE:
*************************
    options = 'AA.COB1'; RESP = '';
*CRT "OFS: ":Y.OFS.QUEUE;
    CALL OFS.POST.MESSAGE(Y.OFS.QUEUE,RESP,options,COMM)

RETURN

END
