* @ValidationCode : MjoyMDYxMzcyMzQwOkNwMTI1MjoxNjg0ODU0MzkzNjI3OklUU1M6LTE6LTE6MTAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 100
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.NCF.ISSUE.SELECT
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This Routine will select all the charges generated during the particular
*month and ganerates NCF for all the charges
*routine
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -VAR.TXN.ACCT.LIST-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 25-MAR-2010        Prabhu.N       ODR-2009-10-0321     Initial Creation
* Date                  who                   Reference              
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.NCF.ISSUED
    $INSERT I_F.REDO.L.NCF.STATUS
    $INSERT I_F.REDO.L.NCF.UNMAPPED
    $INSERT I_REDO.B.NCF.ISSUE.COMMON

    SELECT.NCF.UNMAP.CMD='SELECT ':FN.REDO.L.NCF.UNMAPPED:  ' WITH BATCH  EQ YES'
    CALL EB.READLIST(SELECT.NCF.UNMAP.CMD,VAR.NCF.UNMAPPED.LIST,'',NO.OF.REC,NCF.ERR)
    LOOP
        REMOVE VAR.NCF.UNMAPPED.ID FROM VAR.NCF.UNMAPPED.LIST SETTING UNMAP.POS
    WHILE VAR.NCF.UNMAPPED.ID:UNMAP.POS
        CALL F.READ(FN.REDO.L.NCF.UNMAPPED,VAR.NCF.UNMAPPED.ID,R.NCF.UNMAPPED,F.REDO.L.NCF.UNMAPPED,ERR)
        LOCATE R.NCF.UNMAPPED<ST.UN.TXN.TYPE>:'*':R.NCF.UNMAPPED<ST.UN.ACCOUNT> IN TXN.CODE.LIST SETTING TXN.POS    THEN
            VAR.TXN.ACCT.LIST<TXN.POS>=VAR.TXN.ACCT.LIST<TXN.POS>:'*':VAR.NCF.UNMAPPED.ID
        END
        ELSE
            TXN.CODE.LIST<-1>    =R.NCF.UNMAPPED<ST.UN.TXN.TYPE>:'*':R.NCF.UNMAPPED<ST.UN.ACCOUNT>
            VAR.TXN.ACCT.LIST<-1>=R.NCF.UNMAPPED<ST.UN.TXN.TYPE>:'+':VAR.NCF.UNMAPPED.ID
        END
    REPEAT
    CALL BATCH.BUILD.LIST('',VAR.TXN.ACCT.LIST)
RETURN
END
