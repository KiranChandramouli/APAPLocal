* @ValidationCode : Mjo2ODE1MzkxNzk6Q3AxMjUyOjE2ODQ4NTQzOTg0OTU6SVRTUzotMTotMTo4NDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 84
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.SEC.TRADE(Y.ENQ.ID)
*------------------------------------------------------------------------------------------------------
* DESCRIPTION
* returns the list of IDs that is created as of yesterday in SEC.TRADE application

*------------------------------------------------------------------------------------------------------
* APPLICATION
* build routine to be attached in the enquiry REDO.E.SEC.TRADE
*-------------------------------------------------------------------------------------------------------

*
* Input / Output
* --------------
* IN     : -NA-
* OUT    : Y.ENQ.ID
*
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME :
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO              REFERENCE         DESCRIPTION
*23.08.2010      Janani          ODR-2011-02-0009   INITIAL CREATION
*02.08.2011      Pradeep S       PACS00099908       System date used instead of T24 date
*23.08.2011      Rajagopalan R   PACS00099908       Select in work file F.SEC.TRADES.TODAY based on @ID
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM 
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB INIT
    GOSUB PROCESS
RETURN

*------------------------------------------------------------
INIT:
*------------------------------------------------------------

    FN.SEC.TRADES.TODAY = 'F.SEC.TRADES.TODAY'
    F.SEC.TRADES.TODAY = ''
    CALL OPF(FN.SEC.TRADES.TODAY,F.SEC.TRADES.TODAY)

RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------
*TODAY.DATE = TODAY[3,6]
    Y.VAR = OCONV(DATE(),"D-")
    TODAY.DATE = Y.VAR[9,4]:Y.VAR[1,2]:Y.VAR[4,2]
    Y.STR = 'SCTR'

    SEL.TR.CMD = "SELECT ":FN.SEC.TRADES.TODAY:" WITH @ID LIKE ":ID.COMPANY:"*":Y.STR:"..."
    CALL EB.READLIST(SEL.TR.CMD,SEL.TR.LIST,'',NO.OF.REC,SEL.ERR)
    Y.SEC.ID = FIELDS(SEL.TR.LIST,"*",2,99)
    CHANGE @FM TO " " IN Y.SEC.ID

    Y.ENQ.ID<2,-1> = "@ID"
    Y.ENQ.ID<3,-1> = "EQ"
    Y.ENQ.ID<4,-1> = Y.SEC.ID

RETURN
*------------------------------------------------------------
END
