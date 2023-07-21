* @ValidationCode : MjoxMDc2MDExODU4OkNwMTI1MjoxNjg5OTM2MTExNTc4OklUU1M6LTE6LTE6MTA3OToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Jul 2023 16:11:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1079
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.ASA.RT.SELECT

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts and Removed brackets

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ST.L.APAP.SOYB
    $INSERT I_F.ST.L.APAP.ASAMBLEA.PARAM
    $INSERT I_F.ST.L.APAP.ASAMBLEA.EXCL
    $INSERT I_F.ST.L.APAP.ASAMBLEA.PARTIC
    $INSERT I_LAPAP.ASA.RT.COMMON


    GOSUB DO.CLEAR
    GOSUB DO.SELECT
RETURN

DO.CLEAR:

    CALL OCOMO("INICIO LIMPIEZA TABLAS")

    EXECUTE "CLEAR.FILE FBNK.ST.L.APAP.BALANCE.MENSUAL"         ;*R22 Manual Conversion - Removed brackets
    EXECUTE "CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.PARTIC"         ;*R22 Manual Conversion - Removed brackets
    EXECUTE "CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.EXCL"           ;*R22 Manual Conversion - Removed brackets
    EXECUTE "CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.RELAC"          ;*R22 Manual Conversion - Removed brackets
    EXECUTE "CLEAR.FILE FBNK.ST.L.APAP.BALANCE.MENSUAL$HIS"     ;*R22 Manual Conversion - Removed brackets
    EXECUTE "CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.PARTIC$HIS"     ;*R22 Manual Conversion - Removed brackets
    EXECUTE "CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.EXCL$HIS"       ;*R22 Manual Conversion - Removed brackets
    EXECUTE "CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.RELAC$HIS"      ;*R22 Manual Conversion - Removed brackets
    EXECUTE "CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.VOTANTE$HIS"    ;*R22 Manual Conversion - Removed brackets
    EXECUTE "CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.VOTANTE$NAU"    ;*R22 Manual Conversion - Removed brackets
    EXECUTE "CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.VOTANTE"        ;*R22 Manual Conversion - Removed brackets

    CALL OCOMO("FIN LIMPIEZA TABLAS")

DO.SELECT:
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.SOYB

    CALL OCOMO("COMANDO SELECCION: " : SEL.CMD)

    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.REC)

    CALL OCOMO("LISTA: " : SEL.LIST)

RETURN


END
