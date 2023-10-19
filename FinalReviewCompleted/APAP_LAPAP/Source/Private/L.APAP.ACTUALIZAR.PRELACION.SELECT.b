$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.ACTUALIZAR.PRELACION.SELECT
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION

*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   T24.BP,BP is Removed , INSERT FILE MODIFIED
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_BATCH.FILES ;*R22 MANUAL CONVERSION
    $INSERT  I_TSA.COMMON ;*R22 MANUAL CONVERSION
    $INSERT  I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.AA.PAYMENT.SCHEDULE
    $INSERT   I_F.ST.L.APAP.PRELACION.COVI19.DET
    $INSERT  I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT  I_L.APAP.ACTUALIZAR.PRELACION.COMMON ;*R22 MANUAL CONVERSION


    GOSUB PROCESS
RETURN

PROCESS:
    SEL.CMD = ''; NO.OF.RECS = ''; ERROR.DETAILS = '' ; SEL.LIST = '';
    CALL F.READ(FN.DIRECTORIO,Y.INFILE,R.DIRECTORIO,FV.DIRECTORIO,ERROR.DIRECTORIO)
    SEL.LIST = R.DIRECTORIO
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN
END
