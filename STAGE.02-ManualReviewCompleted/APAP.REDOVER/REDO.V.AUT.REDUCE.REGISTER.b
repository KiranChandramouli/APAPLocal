* @ValidationCode : MjotMTEwMjEyODk2MjpDcDEyNTI6MTY4MTEwNDE4MzQwMzpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 10:53:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.REDUCE.REGISTER
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.GENERATION.RECORD
*-----------------------------------------------------------------------------
*Description  :This routine is Authorisation routine attached to REDO.CARD.DEST.HIST, DESTRUCT version to update STOCK.REGISTER
*Linked With  : version REDO.CARD.DES.HIS,DESTRUCT
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : REDO.CARD.DES.HIS In Read mode
*               STOCK.REGISTER    In Read Mode
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 29-07-2010    Jeyachandran S         ODR-2010-03-0400         Initial Creation

*-------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                          VM TO @VM
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STOCK.REGISTER
    $INSERT I_F.REDO.CARD.DES.HIS

*-------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN
*----------------------------------------------------------------------------------
***********
OPEN.PARA:
***********

    FN.STOCK.REGISTER = 'F.STOCK.REGISTER'
    F.STOCK.REGISTER = ''
    CALL OPF(FN.STOCK.REGISTER, F.STOCK.REGISTER)

    Y.CNT.CARD.NO = 0

RETURN
*-----------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

    Y.CNT.CARD.NO = DCOUNT(R.NEW(REDO.DES.HIS.CARD.NUMBER),@VM)
    Y.STOCK.REGISTER.ID = 'CARD':ID.COMPANY
    GOSUB READ.STOCK.REGISTER
    IF R.STOCK.REGISTER THEN
        LOCATE R.NEW(REDO.DES.HIS.CARD.SERIES) IN R.STOCK.REGISTER<STO.REG.SERIES.ID,1> SETTING POS THEN
            Y.SERIES.BAL = R.STOCK.REGISTER<STO.REG.SERIES.BAL> - Y.CNT.CARD.NO
            R.STOCK.REGISTER<STO.REG.SERIES.BAL> = Y.SERIES.BAL
            Y.SERIES.NO = FIELD(R.STOCK.REGISTER<STO.REG.SERIES.NO>,'-',2)
            Y.NEW.SERIES.NO  = Y.SERIES.NO - Y.CNT.CARD.NO
            R.STOCK.REGISTER<STO.REG.SERIES.NO> = FIELD(R.STOCK.REGISTER<STO.REG.SERIES.NO>,'-',1) : '-' : Y.NEW.SERIES.NO
            CALL F.WRITE(FN.STOCK.REGISTER,Y.STOCK.REGISTER.ID,R.STOCK.REGISTER)
        END
    END

RETURN
*-----------------------------------------------------------------------------------
*******************
READ.STOCK.REGISTER:
*******************
    R.STOCK.REGISTER = ''
    STOCK.REGISTER.ERR = ''
    CALL F.READ(FN.STOCK.REGISTER,Y.STOCK.REGISTER.ID,R.STOCK.REGISTER,F.STOCK.REGISTER,STOCK.REGISTER.ERR)
RETURN
*-----------------------------------------------------------------------------------
END
