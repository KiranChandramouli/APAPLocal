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
*------------------------------------------------------------
*
* Modification History :
*-----------------------
*  DATE             WHO             REFERENCE       DESCRIPTION
*2022-09-12       ROQUEZADA                           CREATE
*----------------------------------------------------------------------
*
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_GTS.COMMON
    $INSERT T24.BP I_System
    $INSERT BP I_F.ST.LAPAP.TRANS.DIVISA.SDT
    $INSERT BP I_F.LAPAP.LOCALIDAD.SDT.EQU
    $INSERT BP I_F.LAPAP.MONEDA.SDT.EQU
    $INSERT BP I_F.LAPAP.TIP.TXN.SDT.EQU
    $INSERT BP I_F.LAPAP.TIP.CHN.SDT.EQU
    $INSERT LAPAP.BP I_LAPAP.PROCESS.TXN.DIV.COMMON

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
