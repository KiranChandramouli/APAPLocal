* @ValidationCode : MjotNzUzOTU4NjM5OkNwMTI1MjoxNjg0ODQyMTUxODI3OklUU1M6LTE6LTE6Mzg1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 385
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.VISA.STLMT.FILE.PROCESS(Y.TXN.ID)
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.STLMT.FILE.PROCESS
*Date              : 23.11.2010
*---------------------------------------------------------------------------
*Description :
*--------------
*This is the multithread program which needs to be executed as the manual POST COB service
*This job will be post job service for REDO.VISA.INITIAL.PROCESS
*Note : this job will do the settlement process to the incoming file and
*hence it is necessary to have SUB ACCOUNT concept applied in the system for the account
*Otherwise process will be slow due to locking
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
* 23/11/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
* 26-Nov-2018     Vignesh Kumaar M R          CI#2795720             BRD001 - FAST FUNDS SERVICES
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          INCLUDE TO INSERT
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON
    $INSERT I_F.REDO.VISA.STLMT.PARAM

    GOSUB INIT
    GOSUB PROCESS
RETURN

*------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------

    CONT.FLAG='FALSE'
    R.REDO.STLMT.LINE=''
    ERROR.MESSAGE=''
    AMT.CHECK='TRUE'
    FLAG=''
    TC.CODE.ALT=''
    CARD.NUMBER=''
    R.VISA.OUTGOING=''
    R.REDO.VISA.STLMT.MAPPING=''
    CHECK.ADD.DIGIT=''
    CARD.TYPE.VAL=''
    AUTH.CODE=''
    Y.ID=''
    Y.STL.ID=''
    R.VISA.OUTGOING=''
    R.ATM.REVERSAL=''
    ATM.REVERSAL.ID=''
    AUTO.CHG.BACK=''
    R.REDO.STLMT.LINE=''
    IN.RTN=''
    ACCT.IN.RTN=''
    IN.USR.DEF.RTN=''
    SET.OCT.FLAG = ''         ;* Fix for 2795720 [BRD001 - FAST FUNDS SERVICES]

RETURN
*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------

    Y.PAR.ID=Y.TXN.ID
    CALL F.READ(FN.REDO.STLMT.CNCT.PROCESS,Y.PAR.ID,R.REDO.STLMT.CNCT.PROCESS,F.REDO.STLMT.CNCT.PROCESS,Y.PARA.ERR)
    Y.FILE.ID=FIELD(Y.TXN.ID,'*',1)
    CALL F.READ(FN.REDO.VISA.CNCT.DATE,Y.FILE.ID,R.REDO.VISA.CNCT.DATE,F.VISA.CNCT.DATE,CNCT.DATE.ERR)
    Y.FILE.DATE=R.REDO.VISA.CNCT.DATE<1>
    IF R.REDO.STLMT.CNCT.PROCESS NE '' THEN
        TC.CODE=R.REDO.STLMT.CNCT.PROCESS<1>[1,2]
        LOCATE TC.CODE IN R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.TXN.CODE,1> SETTING POS.TC  THEN
            IN.RTN=R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.IN.PROCESS.RTN,POS.TC>
            IN.USR.DEF.RTN= R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.IN.USR.DEF.RTN,POS.TC>
            ACCT.IN.RTN= R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.IN.ACCT.RTN,POS.TC>
        END

        IF IN.RTN NE '' THEN
            CALL @IN.RTN(R.REDO.STLMT.CNCT.PROCESS)
        END

        IF CONT.FLAG EQ 'TRUE' THEN
            CALL F.DELETE(FN.REDO.STLMT.CNCT.PROCESS,Y.PAR.ID)
            RETURN
        END
        IF IN.USR.DEF.RTN NE '' THEN
            CALL @IN.USR.DEF.RTN(R.REDO.STLMT.CNCT.PROCESS)
        END
        IF ACCT.IN.RTN NE '' THEN
            CALL @ACCT.IN.RTN
        END
    END
    CALL F.DELETE(FN.REDO.STLMT.CNCT.PROCESS,Y.PAR.ID)

RETURN
END
