*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.CDF.GEN.RT.SELECT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT TAM.BP I_F.REDO.CARD.RENEWAL
    $INSERT ATM.BP I_F.ATM.REVERSAL
    $INSERT TAM.BP I_F.REDO.LY.POINTS
    $INSERT LAPAP.BP I.L.APAP.CDF.GEN.RT.COMMON
    $INSERT BP I_F.ST.COUNT.CDF.GEN.RT

    *--GOSUB INI
    *--GOSUB GET.ACCOUNTS
     GOSUB PROCESS.PARA

**************
PROCESS.PARA:
**************
   
   IF Y.CAN.RUN EQ "SI" THEN
        *--Borra Los Registros Para la tabla del Contador
        CALL EB.CLEAR.FILE(FN.COUNT, FV.COUNT)

        SEL.ACC.CMD = "SELECT " : FN.ACC : " WITH CATEGORY EQ 6021"
        CALL EB.READLIST(SEL.ACC.CMD,SEL.ACC.LIST,"",NO.OF.RECS.ACC,SEL.ACC.ERROR)
        
        *Envia la data de una Rutina a Otra, Cargando el Arreglo de Datos a Memoria
        CALL BATCH.BUILD.LIST('',SEL.ACC.LIST)
   END ELSE
        CALL OCOMO("PROCESO EJECUTADO.")
   END

   RETURN     

END
