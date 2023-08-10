*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.PROC.COBROS.CJ.SELECT

*-----------------------------------------------------------------------------
* Developed By            : APAP
*
* Developed On            : 23-03-2023
*
* Development Reference   : MDR-2479
*
* Development Description : Recibe los TT de autorizaciones de pago via cobros y los procesa de forma masiva haciendo el pago
*                          que corresponde para el producto castigado , legal ect.
* Attached To             : BATCH>BNK/LAPAP.PROC.COBROS.CJ
*
* Attached As             : Multithreaded Routine
*---------------------------------------------------------------------------------
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_GTS.COMMON
    $INCLUDE T24.BP I_BATCH.FILES
    $INCLUDE T24.BP I_TSA.COMMON
    $INCLUDE T24.BP I_F.FUNDS.TRANSFER
    $INCLUDE T24.BP I_F.OFS.SOURCE
    $INCLUDE TAM.BP I_F.REDO.PART.TT.PROCESS
    $INCLUDE T24.BP I_F.ACCOUNT
    $INCLUDE TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INCLUDE LAPAP.BP I_LAPAP.PROC.COBROS.CJ.COMMON


    GOSUB PROCESO

    RETURN

PROCESO:

    CALL F.READ (FN.DIR,Y.INFILE.NAME,R.DIR, FV.DIR, ERROR.DIR)
    IF (R.DIR) THEN
        CALL EB.CLEAR.FILE(FN.LAPAP.COBRO.AUT.WRITE, FV.LAPAP.COBRO.AUT.WRITE)
        SEL.LIST = R.DIR;
        CALL BATCH.BUILD.LIST('',SEL.LIST)
    END

    RETURN


END
