* @ValidationCode : Mjo4MjczNjExMDE6Q3AxMjUyOjE2ODEyMTAxMzM2NDM6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 16:18:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.H.DEPOSIT.RECEIPTS.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.H.DEPOSIT.RECEIPTS.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a authorisation routine to
*Linked With  : REDO.H.DEPOSIT.RECEIPTS.AUTHORISE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                      Reference               Description
*   ------         ------                    -------------            -------------
*  10-10-2011       JEEVA T                     B.42
*  11.04.2023       Conversion Tool             R22                     Auto Conversion     - No changes
*  11.04.2023       Shanmugapriya M             R22                     Manual Conversion   - No changes
*
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.DEPOSIT.RECEIPTS
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.FILE
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
OPEN.FILE:
*--------------------------------------------------------------------------------------------------------

    FN.REDO.ITEM.SERIES = 'F.REDO.ITEM.SERIES'
    F.REDO.ITEM.SERIES =''
    CALL OPF(FN.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES)

RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*--------------------------------------------------------------------------------------------------------

    R.REDO.ITEM.SERIES = ''
    Y.COMPANY = R.NEW(REDO.DEP.BRANCH.DEPT)
    Y.CODE =    R.NEW(REDO.DEP.CODE)
    Y.ITEM =    R.NEW(REDO.DEP.ITEM.CODE)
    Y.FRM =  R.NEW(REDO.DEP.SERIAL.NO)
    Y.STATUS = R.NEW(REDO.DEP.STATUS)
    IF Y.STATUS EQ 'AVAILABLE' THEN
        IF Y.CODE THEN
            Y.ID = Y.COMPANY:'-':Y.CODE:'.':Y.ITEM
        END ELSE
            Y.ID = Y.COMPANY:'.':Y.ITEM
        END
        CALL F.READ(FN.REDO.ITEM.SERIES,Y.ID,R.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES,Y.ERR)
        R.REDO.ITEM.SERIES<-1> = Y.FRM:'*':Y.STATUS:'*':ID.NEW:"*":R.NEW(REDO.DEP.DATE.UPDATED)
        CALL F.WRITE(FN.REDO.ITEM.SERIES,Y.ID,R.REDO.ITEM.SERIES)
    END
RETURN
END
