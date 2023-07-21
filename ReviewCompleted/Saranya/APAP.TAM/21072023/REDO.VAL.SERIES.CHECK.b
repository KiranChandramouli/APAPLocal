* @ValidationCode : MjotMTk4Nzk3ODQxMTpDcDEyNTI6MTY4OTkyNTI0NzM0NDpJVFNTOi0xOi0xOjI3MToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Jul 2023 13:10:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 271
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.SERIES.CHECK
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
*13/07/2023  CONVERSION TOOL                  AUTO R22 CODE CONVERSION- VM TO @VM,FM TO @FM,++ TO +=1
*13/07/2023   VIGNESHWARI	                  MANUAL R22 CODE CONVERSION- Lines are comment
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
    Y.REDO.CARD.REG.STOCK.ID = 'CARD.':FINAL.COMP

    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.COUNT
        Y.SERIES.ID = Y.SERIES<1,Y.CNT>
        Y.STK.QTY = R.NEW(STO.ENT.STOCK.QUANTITY)<1,Y.CNT>
        LOCATE Y.SERIES.ID IN Y.CARD.SERIES SETTING POS THEN
            CALL F.READU(FN.REDO.CARD.REG.STOCK,Y.REDO.CARD.REG.STOCK.ID,R.REDO.CARD.REG.STOCK,F.REDO.CARD.REG.STOCK,Y.ERR.REDO.CARD.REG.STOCK,'')
*            LOCATE Y.SERIES.ID IN R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SERIES.ID,1> SETTING SER.POS THEN  ;*MANUAL R22 CODE CONVERSION-START ---- The variable 'REDO.CARD.REG.STOCK.SER.START.NO' & 'REDO.CARD.REG.STOCK.SERIES.ID' is not found in insert.
*                Y.EXIST = R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SER.START.NO,SER.POS>
*                Y.NEW.START = FIELD(Y.EXIST,'-',2) + Y.STK.QTY
*                Y.NEW.FIRST = FIELD(Y.EXIST,'-',1)
*                R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SER.START.NO,SER.POS> =  Y.NEW.FIRST:'-':Y.NEW.START
*            END ELSE
*                R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SERIES.ID,-1>     =  Y.SERIES.ID
*                R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SER.START.NO,-1> =  1:'-':Y.STK.QTY
*            END ;*;*MANUAL R22 CODE CONVERSION-END
        END ELSE
            AV = Y.CNT
            AF = STO.ENT.STOCK.SERIES
            ETEXT = 'EB-STOCK.NOT.PARA'
            CALL STORE.END.ERROR
        END
        CALL F.WRITE(FN.REDO.CARD.REG.STOCK,Y.REDO.CARD.REG.STOCK.ID,R.REDO.CARD.REG.STOCK)
        Y.CNT += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------
END
