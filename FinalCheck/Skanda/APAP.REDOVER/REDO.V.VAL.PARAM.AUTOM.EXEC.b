* @ValidationCode : MjotMTU5Njc1ODM5NzpDcDEyNTI6MTY4MTk3MzQ1NzkyNTo5MTYzODotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Apr 2023 12:20:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 91638
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.PARAM.AUTOM.EXEC
*------------------------------------------------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.V.VAL.PARAM.AUTOM.EXEC
*Date              : 19.08.2010
*------------------------------------------------------------------------------------------------------------------
*Description:Routine  is used to validate AUTOM.EXEC Field in REDO.INTERFACE.PARAM,MAN Version
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : --N/A--
* Called By : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date              Name              Reference                    Version
* -------           ----              ----------                   --------
* 30.08.2010       Sakthi S          ODR-2010-03-0021             Initial Version
*Modification history
*Date                Who               Reference                  Description
*20-04-2023      conversion tool     R22 Auto code conversion     No changes
*20-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.INTERFACE.PARAM
    IF COMI EQ 'SI' THEN
        T(REDO.INT.PARAM.AUTOM.EXEC.FREC)<3> = ''
    END ELSE
        T(REDO.INT.PARAM.AUTOM.EXEC.FREC)<3> = 'NOINPUT'
    END
RETURN
END
*----------------------------------------------------*END OF SUBROUTINE*-------------------------------------------
