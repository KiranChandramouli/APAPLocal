* @ValidationCode : MjoxNTYzMjU2MTI0OkNwMTI1MjoxNjgzODkyNjI2MDE1OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           VM TO @VM, ++ TO +=
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.GET.NV.VERSION.TYPES(Y.TRANS.ID,Y.VERSION.NAMES,Y.VERSION.TYPES,Y.PROC.TYPE,Y.RECEP.METHOD)
*-----------------------------------------------
*Description: This routine is for Next Version Development
*             to get the version types of the Transaction chain
*-----------------------------------------------
* Input Arg : Transaction ID
* Out Arg   :
*-----------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.MULTITXN.VERSIONS
    $INSERT I_F.REDO.TRANSACTION.CHAIN

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------
OPEN.FILES:
*-----------------------------------------------

    FN.REDO.TRANSACTION.CHAIN = 'F.REDO.TRANSACTION.CHAIN'
    F.REDO.TRANSACTION.CHAIN = ''
    CALL OPF(FN.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN)

    FN.REDO.MULTITXN.VERSIONS = 'F.REDO.MULTITXN.VERSIONS'
    F.REDO.MULTITXN.VERSIONS = ''
    CALL OPF(FN.REDO.MULTITXN.VERSIONS,F.REDO.MULTITXN.VERSIONS)

RETURN
*-----------------------------------------------
PROCESS:
*-----------------------------------------------
********************

    CALL F.READ(FN.REDO.TRANSACTION.CHAIN,Y.TRANS.ID,R.RTC,F.REDO.TRANSACTION.CHAIN,RTC.ERR)
    IF R.RTC ELSE
        RETURN
    END
    Y.VERSION.TYPES = ''
    Y.PROC.TYPE     = ''
    Y.RECEP.METHOD  = ''
    Y.VERSION.NAMES = R.RTC<RTC.TRANS.VERS>
    Y.TRANSACTION.REF = R.RTC<RTC.TRANS.ID>
    Y.TRANS.CNT = DCOUNT(Y.TRANSACTION.REF,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.TRANS.CNT
        Y.VERSION = Y.VERSION.NAMES<1,Y.VAR1>
        GOSUB GET.VERSION.TYPE

        Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

RETURN
*-----------------------------------------------
GET.VERSION.TYPE:
*-----------------------------------------------
    SEL.CMD = 'SELECT ':FN.REDO.MULTITXN.VERSIONS:' WITH VERSION.NAME EQ ':Y.VERSION
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    Y.MUL.TXN.ID = SEL.LIST<1>
    CALL F.READ(FN.REDO.MULTITXN.VERSIONS,Y.MUL.TXN.ID,R.REDO.MULTITXN.VERSIONS,F.REDO.MULTITXN.VERSIONS,MULTXN.ERR)
    IF R.REDO.MULTITXN.VERSIONS THEN
        Y.VERSION.TYPES<-1> = R.REDO.MULTITXN.VERSIONS<RMV.VERSION.TYPE>
        Y.PROC.TYPE<-1>     = R.REDO.MULTITXN.VERSIONS<RMV.PROC.TYPE>
        Y.RECEP.METHOD<-1>  = R.REDO.MULTITXN.VERSIONS<RMV.RECEP.METHOD>
    END

RETURN
END
