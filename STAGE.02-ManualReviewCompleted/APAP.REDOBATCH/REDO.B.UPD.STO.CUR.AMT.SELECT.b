* @ValidationCode : MjoyNDI5MzM0NTI6Q3AxMjUyOjE2ODEzNjU3MDEwODQ6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 11:31:41
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
SUBROUTINE REDO.B.UPD.STO.CUR.AMT.SELECT
*----------------------------------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is the SELECT routine of the batch job REDO.B.UPD.STO.CUR.AMT
*   which updates the STANDING.ORDER CURRENT.AMOUNT, L.LOAN.STATUS.1 & L.LOAN.COND
* This routine selects STANDING.ORDER records processed on the current date
* ----------------------------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference                     Description
* 03-JUN-2010   N.Satheesh Kumar  TAM-ODR-2009-10-0331           Initial Creation
* Date                  who                   Reference              
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.UPD.STO.CUR.AMT.COMMON

    SEL.CMD = 'SELECT ':FN.STANDING.ORDER:' WITH LAST.RUN.DATE EQ ':TODAY:' AND WITH L.LOAN.ARR.ID NE ""'
    CALL EB.READLIST(SEL.CMD,STO.SEL.LST,'',NO.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',STO.SEL.LST)
RETURN
END
