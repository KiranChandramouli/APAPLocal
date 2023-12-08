$PACKAGE APAP.LAPAP
* @ValidationCode : MjotMTk0NDkyMDE2NTpDcDEyNTI6MTcwMjAzMTU5NzU2MDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 Dec 2023 16:03:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.ACTUALIZAR.PRELACION.LOAD
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION

*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   T24.BP,BP is Removed, INSERT FILE MODIFIED
* 08-12-2023      Suresh           Manual R22 conversion  OPF TO OPEN
*----------------------------------------------------------------------------------------

    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT I_BATCH.FILES ;*R22 MANUAL CONVERSION
    $INSERT  I_TSA.COMMON
    $INSERT  I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.AA.PAYMENT.SCHEDULE
    $INSERT  I_F.ST.L.APAP.PRELACION.COVI19.DET ;*R22 MANUAL CONVERSION
    $INSERT  I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT  I_L.APAP.ACTUALIZAR.PRELACION.COMMON ;*R22 MANUAL CONVERSION

    GOSUB TABLAS

RETURN

TABLAS:
    FN.L.APAP.COVI.PRELACIONIII = 'F.ST.L.APAP.COVI.PRELACIONIII'
    FV.L.APAP.COVI.PRELACIONIII = ''
    CALL OPF (FN.L.APAP.COVI.PRELACIONIII,FV.L.APAP.COVI.PRELACIONIII)

    FN.FT = 'F.FUNDS.TRANSFER'
    FV.FT = ''
    CALL OPF (FN.FT,FV.FT)

    FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
    FV.AAA = ''
    CALL OPF (FN.AAA,FV.AAA)

    FN.L.APAP.PRELACION.COVI19.DET = 'F.ST.L.APAP.PRELACION.COVI19.DET'
    FV.L.APAP.PRELACION.COVI19.DET = ''
    CALL OPF (FN.L.APAP.PRELACION.COVI19.DET,FV.L.APAP.PRELACION.COVI19.DET)

    FN.DIRECTORIO = "&SAVEDLISTS&"
    FV.DIRECTORIO = ""
*   CALL OPF (FN.DIRECTORIO,FV.DIRECTORIO)
    OPEN FN.DIRECTORIO TO FV.DIRECTORIO ELSE  ;*R22 Manual Conversion
    END  ;*R22 Manual Conversion
    

    Y.FECHA.DESMONTE = '20210329'
    Y.INFILE = 'INFILE.PRELACION.txt'

RETURN



END
