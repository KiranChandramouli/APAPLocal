SUBROUTINE REDO.B.ARC.OFS.PROCESS
*------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By   : Riyas Ahamaad Basha
* Program Name  : REDO.B.ARC.OFS.PROCESS
* ODR           : ODR-2010-08-0031
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES


    GOSUB INIT.PROCESS
    GOSUB MAIN.PROCESS
    GOSUB GOEND
RETURN

*------------------------------------------------------------------------------------------
INIT.PROCESS:
*------------------------------------------------------------------------------------------

    FN.AI.REDO.OFS.QUEUE = 'F.AI.REDO.OFS.QUEUE'
    F.AI.REDO.OFS.QUEUE  = ''
    CALL OPF(FN.AI.REDO.OFS.QUEUE,F.AI.REDO.OFS.QUEUE)
    OFS.SOURCE.ID =  'OFSUPDATE'

RETURN
*------------------------------------------------------------------------------------------
MAIN.PROCESS:
*------------------------------------------------------------------------------------------

    SEL.CMD   = "SELECT " :FN.AI.REDO.OFS.QUEUE
    CALL EB.READLIST(SEL.CMD,SEL.OFS.LIST,'',SEL.OFS.CNT,OFS.ERR)
    LOOP
        REMOVE ARC.OFS.ID FROM SEL.OFS.LIST SETTING AI.OFS.MSG.POS
    WHILE ARC.OFS.ID : AI.OFS.MSG.POS

*    READ OFS.STRING FROM F.AI.REDO.OFS.QUEUE,ARC.OFS.ID THEN ;*Tus Start
        CALL F.READ(FN.AI.REDO.OFS.QUEUE,ARC.OFS.ID,OFS.STRING,F.AI.REDO.OFS.QUEUE,OFS.STRING.ERR)
        IF OFS.STRING THEN  ;* Tus End

            IF ARC.OFS.ID[1,2] EQ 'FT' THEN

                CALL OFS.CALL.BULK.MANAGER(OFS.SOURCE.ID,OFS.STRING,Y.theResponse, Y.txnCommitted)

            END ELSE

                Y.RUNNING.UNDER.BATCH = RUNNING.UNDER.BATCH
                RUNNING.UNDER.BATCH = 0
                CALL OFS.CALL.BULK.MANAGER(OFS.SOURCE.ID,OFS.STRING,Y.theResponse, Y.txnCommitted)
                RUNNING.UNDER.BATCH = Y.RUNNING.UNDER.BATCH

                IF NOT(Y.txnCommitted) THEN
                    CHANGE ',' TO @FM IN OFS.STRING
                    Y.LEN.OFS.STRING = DCOUNT(OFS.STRING,@FM)
                    DEL OFS.STRING<Y.LEN.OFS.STRING-1>
                    CHANGE @FM TO ',' IN OFS.STRING
                    Y.RUNNING.UNDER.BATCH = RUNNING.UNDER.BATCH
                    RUNNING.UNDER.BATCH = 0
                    CALL OFS.CALL.BULK.MANAGER(OFS.SOURCE.ID,OFS.STRING,Y.theResponse, Y.txnCommitted)
                    RUNNING.UNDER.BATCH = Y.RUNNING.UNDER.BATCH
                END

            END

        END
        CALL F.DELETE(FN.AI.REDO.OFS.QUEUE,ARC.OFS.ID)
    REPEAT
RETURN

GOEND:
END
*-----------------------------------------*END OF SUBROUTINE*------------------------------
