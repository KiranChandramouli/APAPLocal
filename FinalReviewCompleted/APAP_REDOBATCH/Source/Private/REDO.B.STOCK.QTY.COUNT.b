* @ValidationCode : Mjo2NDQ0NDg3MDU6Q3AxMjUyOjE2ODQ4NTQzOTk0NDY6SVRTUzotMTotMTozOTE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 391
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.STOCK.QTY.COUNT(Y.SR.SEL.LIST)
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.STOCK.QTY.COUNT
*------------------------------------------------------------------------------
*DESCRIPTION:This routine is COB routine to select all STOCK.ENTRY and calculate destruction date. Attach to D990 stage
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.UPDATE.DESTRUCTION
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*31-07-2010    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - VM TO @VM 
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.USER
    $INSERT I_F.STOCK.REGISTER
    $INSERT I_F.DATES
    $INSERT I_REDO.B.STOCK.QTY.COUNT.COMMON
    $INSERT I_F.REDO.STOCK.QTY.COUNT
    $INSERT I_F.COMPANY
*--------------------------------------------------------------------------
    FINAL.COMP = R.COMPANY(EB.COM.FINANCIAL.COM)

    IF ID.COMPANY NE FINAL.COMP THEN
        GOSUB PROCESS
    END

RETURN
*---------------------------------------------------------------------------
*---------
PROCESS:
*---------
*WRITE THE DAILY STOCK TO REDO.STOCK.QTY.COUNT TABLE

    CALL F.READ(FN.STOCK.REGISTER,Y.SR.SEL.LIST,R.STOCK.REGISTER,F.STOCK.REGISTER,Y.ERR.SR)
    IF R.STOCK.REGISTER NE '' THEN
        Y.CARD.SERIES = R.STOCK.REGISTER<STO.REG.SERIES.ID>
        CALL F.READ(FN.DATES,ID.COMPANY,R.DAT,F.DATES,Y.ER.DAT)

        Y.DATE = R.DAT<EB.DAT.LAST.WORKING.DAY>
        TYPE.CNTR = DCOUNT(Y.CARD.SERIES,@VM)
        LOOP.CNTR =1
        LOOP
        WHILE LOOP.CNTR LE TYPE.CNTR
            Y.SERIES.ID = Y.CARD.SERIES<1,LOOP.CNTR>
            Y.STOCK.QTY.COUNT.ID = FIELD(Y.SERIES.ID,'*',2,1)
            Y.YY.MM = Y.DATE[1,4]
            Y.STOCK.QTY.COUNT.ID = Y.STOCK.QTY.COUNT.ID:'-':Y.YY.MM
            CALL F.READ(FN.REDO.STOCK.QTY.COUNT,Y.STOCK.QTY.COUNT.ID,R.REDO.STOCK.QTY.COUNT,F.REDO.STOCK.QTY.COUNT,Y.ERR.STK.CNT)
            LOCATE Y.DATE IN R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.DATE,1> SETTING DATE.POS THEN
                R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.DATE,DATE.POS> = Y.DATE
                R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.STOCK.QTY,DATE.POS>= R.STOCK.REGISTER<STO.REG.SERIES.BAL,LOOP.CNTR>
            END ELSE
                R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.DATE,-1> = Y.DATE
                R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.STOCK.QTY,-1>= R.STOCK.REGISTER<STO.REG.SERIES.BAL,LOOP.CNTR>
            END
            CALL F.WRITE(FN.REDO.STOCK.QTY.COUNT,Y.STOCK.QTY.COUNT.ID,R.REDO.STOCK.QTY.COUNT)
            LOOP.CNTR += 1
        REPEAT
    END
RETURN
END
