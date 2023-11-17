$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ITSS.IBSOLUTION.ARCIB.MIG.SELECT
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_IBSOLUTION.ARCIB.MIG.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN


INIT:
RETURN

PROCESS:

    Y.LIST.FINAL = ""
    SEL.COMMAND = "SELECT F.EB.EXTERNAL.USER WITH CHANNEL NE TELEFONO"
    CALL EB.READLIST(SEL.COMMAND,Y.LIST.FINAL,'',NO.OF.REC,ERR)

    CALL BATCH.BUILD.LIST("",Y.LIST.FINAL)

RETURN
