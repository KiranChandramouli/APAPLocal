* @ValidationCode : Mjo0NTM0MzcxMjA6Q3AxMjUyOjE2OTI3NzI2NDk1ODU6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 Aug 2023 12:07:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
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
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.PROCESS.TXN.DIVI.LOAD
***********************************************************
*----------------------------------------------------------
*
* COMPANY NAME    : APAP
* DEVELOPED BY    : ROQUEZADA
*
*----------------------------------------------------------
*
* DESCRIPTION     : AUTHORISATION routine to be used in FT versions
*                   to save USD/EUR transfer in historic table
*------------------------------------------------------------------------------------------------
*
* Modification History :
*-----------------------
*  DATE             WHO             REFERENCE              DESCRIPTION
*2022-09-12       ROQUEZADA                                  CREATE
*09/08/2023       VIGNESHWARI  MANUAL R22 CODE CONVERSION  T24.BP,BP & LAPAP.BP is removed in insertfile
*--------------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON ;*MANUAL R22 CODE CONVERSION-START: T24.BP is removed in insertfile
    $INSERT  I_EQUATE
    $INSERT  I_GTS.COMMON
    $INSERT  I_System     ;*MANUAL R22 CODE CONVERSION-END
    $INSERT  I_F.ST.LAPAP.TRANS.DIVISA.SDT ;*MANUAL R22 CODE CONVERSION-START:BP is removed in insertfile
    $INSERT  I_F.LAPAP.LOCALIDAD.SDT.EQU    
    $INSERT  I_F.LAPAP.MONEDA.SDT.EQU
    $INSERT  I_F.LAPAP.TIP.TXN.SDT.EQU
    $INSERT  I_F.LAPAP.TIP.CHN.SDT.EQU ;*MANUAL R22 CODE CONVERSION-END
    $INSERT  I_LAPAP.PROCESS.TXN.DIV.COMMON ;*MANUAL R22 CODE CONVERSION -LAPAP.BP is removed in insertfile


    GOSUB LOAD
    GOSUB CONS.VALUES


    RETURN

* ===
LOAD:
* ===
Y.STATUS.REG = 'PENDIENTE';

* TRANS.DIVISA.SDT
FN.TRANS.DIVISA.SDT = 'F.ST.LAPAP.TRANS.DIVISA.SDT';
F.TRANS.DIVISA.SDT = '';
CALL OPF(FN.TRANS.DIVISA.SDT,F.TRANS.DIVISA.SDT)

* LOCALIDAD.SDT
FN.LOCALIDAD.SDT = 'F.ST.LAPAP.LOCALIDAD.SDT.EQU';
F.LOCALIDAD.SDT = ''; LOCALIDAD.ERR = '';
CALL OPF(FN.LOCALIDAD.SDT,F.LOCALIDAD.SDT)

* TIPO.TRANS.SDT
FN.TIPO.TRANS.SDT = 'F.ST.LAPAP.TIP.TXN.SDT.EQU';
F.TIPO.TRANS.SDT = '';TIPO.TRANS.ERR = '';
CALL OPF(FN.TIPO.TRANS.SDT,F.TIPO.TRANS.SDT)

* TIPO.CAMBIO.SDT
FN.TIPO.CAMBIO.SDT = 'F.ST.LAPAP.TIP.CHN.SDT.EQU';
F.TIPO.CAMBIO.SDT = '';TIPO.CAMBIO.ERR = '';
CALL OPF(FN.TIPO.CAMBIO.SDT,F.TIPO.CAMBIO.SDT)

* MONEDA.SDT
FN.MONEDA.SDT = 'F.ST.LAPAP.MONEDA.SDT.EQU';
F.MONEDA.SDT = ''; MONEDA.ERR = '';
CALL OPF(FN.MONEDA.SDT,F.MONEDA.SDT)


RETURN

CONS.VALUES:

CALL F.READ(FN.LOCALIDAD.SDT,"SYSTEM",R.LOCALIDAD,F.LOCALIDAD.SDT,LOCALIDAD.ERR)

CALL F.READ(FN.TIPO.CAMBIO.SDT,"SYSTEM",R.TIPO.CAMBIO,F.TIPO.CAMBIO.SDT,TIPO.CAMBIO.ERR)

CALL F.READ(FN.TIPO.TRANS.SDT,"SYSTEM",R.TIPO.TRANS,F.TIPO.TRANS.SDT,TIPO.TRANS.ERR)

CALL F.READ(FN.MONEDA.SDT,"SYSTEM",R.MONEDA,F.MONEDA.SDT,MONEDA.ERR)

RETURN

END
