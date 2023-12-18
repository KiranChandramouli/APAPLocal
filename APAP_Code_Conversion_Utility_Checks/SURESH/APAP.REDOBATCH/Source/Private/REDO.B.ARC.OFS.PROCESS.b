* @ValidationCode : MjoxMDI2MDU0NTQ6Q3AxMjUyOjE3MDI4OTA4NzMxNjk6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Dec 2023 14:44:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.ARC.OFS.PROCESS
*------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By   : Riyas Ahamaad Basha
* Program Name  : REDO.B.ARC.OFS.PROCESS
* ODR           : ODR-2010-08-0031
* Date                  who                   Reference
* 06-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION FM TO @FM
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/12/2023           Suresh               R22 Manual Conversion  -CALL routine modified
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    
    $USING EB.Interface ;*R22 Manual Conversion


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

*                CALL OFS.CALL.BULK.MANAGER(OFS.SOURCE.ID,OFS.STRING,Y.theResponse, Y.txnCommitted)
                EB.Interface.OfsCallBulkManager(OFS.SOURCE.ID,OFS.STRING,Y.theResponse, Y.txnCommitted) ;*R22 Manual Conversion

            END ELSE

                Y.RUNNING.UNDER.BATCH = RUNNING.UNDER.BATCH
                RUNNING.UNDER.BATCH = 0
*               CALL OFS.CALL.BULK.MANAGER(OFS.SOURCE.ID,OFS.STRING,Y.theResponse, Y.txnCommitted)
                EB.Interface.OfsCallBulkManager(OFS.SOURCE.ID,OFS.STRING,Y.theResponse, Y.txnCommitted) ;*R22 Manual Conversion
                RUNNING.UNDER.BATCH = Y.RUNNING.UNDER.BATCH

                IF NOT(Y.txnCommitted) THEN
                    CHANGE ',' TO @FM IN OFS.STRING
                    Y.LEN.OFS.STRING = DCOUNT(OFS.STRING,@FM)
                    DEL OFS.STRING<Y.LEN.OFS.STRING-1>
                    CHANGE @FM TO ',' IN OFS.STRING
                    Y.RUNNING.UNDER.BATCH = RUNNING.UNDER.BATCH
                    RUNNING.UNDER.BATCH = 0
*                    CALL OFS.CALL.BULK.MANAGER(OFS.SOURCE.ID,OFS.STRING,Y.theResponse, Y.txnCommitted)
                    EB.Interface.OfsCallBulkManager(OFS.SOURCE.ID,OFS.STRING,Y.theResponse, Y.txnCommitted) ;*R22 Manual Conversion
                    
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
