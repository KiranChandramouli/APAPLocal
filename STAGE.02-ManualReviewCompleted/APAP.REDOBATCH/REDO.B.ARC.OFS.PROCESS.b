* @ValidationCode : MjoxMDAyMDg1NDAwOkNwMTI1MjoxNjgwNzgxMTIxMTEyOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:08:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
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
* 06-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION FM TO @FM
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
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
