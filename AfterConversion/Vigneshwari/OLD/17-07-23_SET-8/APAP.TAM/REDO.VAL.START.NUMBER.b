* @ValidationCode : MjotMTU4ODg3NDYwMzpDcDEyNTI6MTY4OTgzOTk3NTI4Mzp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Jul 2023 13:29:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.START.NUMBER
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEEVA T
* PROGRAM NAME: REDO.AUTO.TO.REGIS
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for REDO.AUTO.TO.REGIS to
* default the value for the  STOCK.ENTRY application from REDO.MULTI.TXN.PROCESS
* It is AUTOM NEW CONTENT routine

*IN PARAMETER : NA
*OUT PARAMETER: NA
*LINKED WITH  : REDO.AUTO.TO.REGIS
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
* DATE           WHO           REFERENCE         DESCRIPTION
*16-11-2010   JEEVA T           B.166A           INITIAL CREATION
*13/07/2023   CONVERSION TOOL             AUTO R22 CODE CONVERSION- VM TO @VM,FM TO @FM,++ TO +=1
*13/07/2023    VIGNESHWARI	              MANUAL R22 CODE CONVERSION- Lines are comment
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.STOCK.ENTRY
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.CARD.SERIES.PARAM
    $INSERT I_F.REDO.CARD.REG.STOCK

    GOSUB INIT
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------



    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
    F.REDO.CARD.SERIES.PARAM = ''
*CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM) ;*Tus S/E

    FN.REDO.CARD.REG.STOCK = 'F.REDO.CARD.REG.STOCK'
    F.REDO.CARD.REG.STOCK = ''
    CALL OPF(FN.REDO.CARD.REG.STOCK,F.REDO.CARD.REG.STOCK)

RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.CARD.SERIES.PARAM,Y.ID,R.REDO.CARD.SERIES.PARAM,PRO.ERR)
    Y.CARD.SERIES = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.SERIES>
    CHANGE @VM TO @FM IN Y.CARD.SERIES
    Y.SERIES = R.NEW(STO.ENT.STOCK.SERIES)
    Y.COUNT = DCOUNT(Y.SERIES,@VM)
    FINAL.COMP = R.COMPANY(EB.COM.FINANCIAL.COM)
    VIRGIN.DEPT.CODE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.VIRGIN.DEPT.CODE>
*  Y.REDO.CARD.REG.STOCK.ID = 'CARD.':FINAL.COMP:'-':VIRGIN.DEPT.CODE
* changing the ID of REDO.CARD.REG.STOCK to car.financial company
    Y.REDO.CARD.REG.STOCK.ID = 'CARD.':FINAL.COMP

    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.COUNT
        Y.SERIES.ID = Y.SERIES<1,Y.CNT>
        Y.STK.QTY = R.NEW(STO.ENT.STOCK.QUANTITY)<1,Y.CNT>
        LOCATE Y.SERIES.ID IN Y.CARD.SERIES SETTING POS THEN
            CALL F.READ(FN.REDO.CARD.REG.STOCK,Y.REDO.CARD.REG.STOCK.ID,R.REDO.CARD.REG.STOCK,F.REDO.CARD.REG.STOCK,Y.ERR.REDO.CARD.REG.STOCK)
            Y.STOCK.SERIES.ID=''
*            Y.STOCK.SERIES.ID = R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SERIES.ID>  ;*MANUAL R22 CODE CONVERSION- 'REDO.CARD.REG.STOCK.SERIES.ID' is not found in insert
            CHANGE @VM TO @FM IN Y.STOCK.SERIES.ID
            LOCATE Y.SERIES.ID IN Y.STOCK.SERIES.ID SETTING SER.POS THEN
*                Y.EXIST = R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SER.START.NO,SER.POS>   ;*MANUAL R22 CODE CONVERSION - "REDO.CARD.REG.STOCK.SER.START.NO" is not found in insert
                Y.NEW.SECOND = FIELD(Y.EXIST,'-',2)
                R.NEW(STO.ENT.STOCK.START.NO)<1,Y.CNT>= Y.NEW.SECOND + 1

            END ELSE
                R.NEW(STO.ENT.STOCK.START.NO)<1,Y.CNT>= 1

            END

        END


        Y.CNT += 1
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------------
END
