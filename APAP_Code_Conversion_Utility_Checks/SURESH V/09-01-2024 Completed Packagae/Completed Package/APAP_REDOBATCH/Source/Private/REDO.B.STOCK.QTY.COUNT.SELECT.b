* @ValidationCode : Mjo0NDM5NzgzMTk6Q3AxMjUyOjE3MDQ0NDE5OTM2NjY6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jan 2024 13:36:33
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
SUBROUTINE REDO.B.STOCK.QTY.COUNT.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.STOCK.QTY.COUNT.SELECT
*------------------------------------------------------------------------------
*DESCRIPTION:This is a Multi threaded Select Routine Which is used to select
*the Stock register table
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.STOCK.QTY.COUNT
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*8-MARCH-2011    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.STOCK.QTY.COUNT.COMMON
    $INSERT I_GTS.COMMON
*    $INSERT I_BATCH.FILES ;*R22 Manual Conversion
    $INSERT I_F.DATES
    $INSERT I_F.STOCK.REGISTER
    $INSERT I_F.REDO.CARD.SERIES.PARAM
    $USING EB.Service

*    CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)
    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM';* R22 UTILITY AUTO CONVERSION
*    CALL CACHE.READ(FN.REDO.CARD.SERIES.PARAM,'SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR);* R22 UTILITY AUTO CONVERSION
    IDVAR.1 = 'SYSTEM' ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.CARD.SERIES.PARAM,IDVAR.1,R.REDO.CARD.SERIES.PARAM,PARAM.ERR);* R22 UTILITY AUTO CONVERSION;* R22 UTILITY AUTO CONVERSION
    Y.RECD.DEPT = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.RECEIVE.DEPT.CODE>
    SEL.CMD.SR = "SELECT ":FN.STOCK.REGISTER:" WITH @ID EQ CARD.":ID.COMPANY:"-":Y.RECD.DEPT
    CALL EB.READLIST(SEL.CMD.SR,SEL.LIST.SR,'',NO.REC,PGM.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST.SR)
    EB.Service.BatchBuildList('',SEL.LIST.SR);* R22 UTILITY AUTO CONVERSION
RETURN

END
