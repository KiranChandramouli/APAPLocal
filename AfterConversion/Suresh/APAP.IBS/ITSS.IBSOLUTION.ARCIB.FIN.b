$PACKAGE APAP.IBS

*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ITSS.IBSOLUTION.ARCIB.FIN
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    Y.CMD = "./arcib_mig_clean.sh"
    EXECUTE Y.CMD CAPTURING Y.VAR


RETURN
