$PACKAGE APAP.LAPAP
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
    CALL OPF (FN.DIRECTORIO,FV.DIRECTORIO)

    Y.FECHA.DESMONTE = '20210329'
    Y.INFILE = 'INFILE.PRELACION.txt'

RETURN



END
