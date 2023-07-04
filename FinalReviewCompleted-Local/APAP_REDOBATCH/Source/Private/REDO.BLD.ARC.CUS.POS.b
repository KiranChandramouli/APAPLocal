* @ValidationCode : MjoxNjcxOTYxMDkxOkNwMTI1MjoxNjgwNzkwMTEwNTMyOklUU1M6LTE6LTE6LTEwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -10
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BLD.ARC.CUS.POS(ENQ.DATA)

*------------------------------------------------------------------------
*Description : This is a build routine used to send the value for selection
* field using the common variable !EXT.SMS.CUSTOMERS
*
*------------------------------------------------------------------------
* Input Argument : ENQ.DATA
* Out Argument   : ENQ.DATA
* Deals With     : ENQUIRY

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO        	       REFERENCE            DESCRIPTION
* 03-MAR-2011     H GANESH  	  ODR-2010-10-0045 N.107   Initial Draft
* 04-APR-2023     Conversion tool    R22 Auto conversion   if condition added
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
* This will assign the value for selection field @id

    Y.VAR.EXT.CUSTOMER = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - START
        Y.VAR.EXT.CUSTOMER = ""
    END                                ;*R22 Auto conversion - STOP

    IF ENQ.DATA<1,1> EQ 'AI.REDO.CREDIT.CUSTOMER.POSITION' OR ENQ.DATA<1,1> EQ 'REDO.CREDIT.CUSTOMER.POSITION' OR  ENQ.DATA<1,1> EQ 'AI.REDO.LIST.CARD.CUSTOMER' THEN
        ENQ.DATA<2,-1>='CLIENT.ID'
        ENQ.DATA<3,-1>='EQ'
        ENQ.DATA<4,-1>=Y.VAR.EXT.CUSTOMER
    END ELSE
        ENQ.DATA<2,-1>='@ID'
        ENQ.DATA<3,-1>='EQ'
        ENQ.DATA<4,-1>=Y.VAR.EXT.CUSTOMER
    END
RETURN
END
