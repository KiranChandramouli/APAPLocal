* @ValidationCode : MjozNTk3Mzk5NzpDcDEyNTI6MTY4MjQxMjMzODMxNzpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.UPD
*-----------------------------------------------------------------------------

*------------
*DESCRIPTION:
*-----------------------------------------------------------------------------------------
*  This routine is attached as a authorization routine for the version
*  EB.SECURE.MESSAGE,MSG.REV and it will update REDO.T.MSG.DET with customer id as @ID
*------------------------------------------------------------------------------------------

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
* 10-FEB-2010       Prabhu.N       ODR-2009-12-0279    Initial Creation

*------------------------------------------------------------------------------------------

*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*10-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*10-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*---------------------------------------------------------------------------------------
 
 

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.SECURE.MESSAGE

    GOSUB INIT
    GOSUB PROCESS
RETURN
*------
INIT:
*------
    FN.REDO.T.MSG.DET='F.REDO.T.MSG.DET'
    F.REDO.T.MSG.DET=''
    CALL OPF(FN.REDO.T.MSG.DET,F.REDO.T.MSG.DET)
RETURN
*-------
PROCESS:
*-------
    Y.CUSTOMER.ID=R.NEW(EB.SM.TO.CUSTOMER)
    R.MSG.DET=ID.NEW
    CALL F.WRITE(FN.REDO.T.MSG.DET,Y.CUSTOMER.ID,R.MSG.DET)
RETURN
END
